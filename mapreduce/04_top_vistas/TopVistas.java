package top_vistas;

import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/**
 * ============================================================
 * JOB 04: TOP 10 CONTENIDO MAS VISTO
 * Dataset: streaming_ampliado.csv
 *
 * Analisis: Identifica los 10 titulos con mayor numero
 * de visualizaciones en la plataforma.
 * Usa un TreeMap en el Reducer para ordenar y limitar a Top 10.
 *
 * Columnas CSV:
 *   0:titulo, 1:tipo, 2:anio, 3:director,
 *   4:genero_1, ... 7:idioma, 8:puntuacion, 9:vistas, ...
 * ============================================================
 */
public class TopVistas {

    // --------------------------------------------------------
    // MAPPER: Emite (titulo, vistas) para cada fila valida
    // --------------------------------------------------------
    public static class VistaMapper
            extends Mapper<LongWritable, Text, Text, LongWritable> {

        private final Text        tituloKey  = new Text();
        private final LongWritable vistasVal = new LongWritable();

        @Override
        public void map(LongWritable clave, Text valor, Context contexto)
                throws IOException, InterruptedException {

            String linea = valor.toString().trim();

            if (linea.startsWith("titulo") || linea.isEmpty()) return;

            String[] campos = linea.split(",", -1);
            if (campos.length < 10) return;

            String titulo  = campos[0].trim();
            String tipo    = campos[1].trim();
            String vistasS = campos[9].trim();

            if (titulo.isEmpty() || vistasS.isEmpty()) return;

            try {
                long vistas = Long.parseLong(vistasS);
                tituloKey.set(titulo + " [" + tipo + "]");
                vistasVal.set(vistas);
                contexto.write(tituloKey, vistasVal);
            } catch (NumberFormatException e) {
                // Ignorar
            }
        }
    }

    // --------------------------------------------------------
    // REDUCER: Mantiene un TreeMap con Top 10 por vistas
    // TreeMap<Long, String> ordena de menor a mayor (clave=vistas)
    // --------------------------------------------------------
    public static class TopReducer
            extends Reducer<Text, LongWritable, Text, LongWritable> {

        private static final int TOP_N = 10;
        private final TreeMap<Long, String> topMap = new TreeMap<>();

        @Override
        public void reduce(Text clave, Iterable<LongWritable> valores, Context contexto)
                throws IOException, InterruptedException {

            long totalVistas = 0L;
            for (LongWritable v : valores) {
                totalVistas += v.get();
            }

            topMap.put(totalVistas, clave.toString());

            // Mantener solo el Top N (eliminar el menor si supera el límite)
            if (topMap.size() > TOP_N) {
                topMap.pollFirstEntry(); // Elimina el de menor vistas
            }
        }

        @Override
        protected void cleanup(Context contexto)
                throws IOException, InterruptedException {

            // Emitir en orden descendente (de mayor a menor vistas)
            int posicion = topMap.size();
            for (Map.Entry<Long, String> entrada : topMap.entrySet()) {
                contexto.write(
                    new Text("#" + posicion + " " + entrada.getValue()),
                    new LongWritable(entrada.getKey())
                );
                posicion--;
            }
        }
    }

    // --------------------------------------------------------
    // DRIVER
    // --------------------------------------------------------
    public static void main(String[] args) throws Exception {

        if (args.length != 2) {
            System.err.println("Uso: TopVistas <entrada_hdfs> <salida_hdfs>");
            System.exit(1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Top 10 Contenido Mas Visto");

        job.setJarByClass(TopVistas.class);
        job.setMapperClass(VistaMapper.class);
        job.setReducerClass(TopReducer.class);

        // Un solo reducer para garantizar el Top N global
        job.setNumReduceTasks(1);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(LongWritable.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(LongWritable.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        boolean exito = job.waitForCompletion(true);
        System.exit(exito ? 0 : 1);
    }
}
