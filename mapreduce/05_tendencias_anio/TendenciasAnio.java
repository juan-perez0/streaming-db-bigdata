package tendencias_anio;

import java.io.IOException;
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
 * JOB 05: TENDENCIAS DE PRODUCCION POR AÑO
 * Dataset: streaming_ampliado.csv
 *
 * Analisis: Por cada año de estreno calcula:
 *  - Total de titulos lanzados
 *  - Desglose: peliculas vs series
 *  - Puntuacion promedio del contenido de ese año
 *  - Total de vistas acumuladas
 *
 * Columnas CSV:
 *   0:titulo, 1:tipo, 2:anio, ... 8:puntuacion, 9:vistas, ...
 * ============================================================
 */
public class TendenciasAnio {

    // --------------------------------------------------------
    // MAPPER: Emite (anio, "tipo|puntuacion|vistas")
    // --------------------------------------------------------
    public static class AnioMapper
            extends Mapper<LongWritable, Text, Text, Text> {

        private final Text anioKey  = new Text();
        private final Text datoVal  = new Text();

        @Override
        public void map(LongWritable clave, Text valor, Context contexto)
                throws IOException, InterruptedException {

            String linea = valor.toString().trim();

            if (linea.startsWith("titulo") || linea.isEmpty()) return;

            String[] campos = linea.split(",", -1);
            if (campos.length < 10) return;

            String anio       = campos[2].trim();
            String tipo       = campos[1].trim();
            String puntuacion = campos[8].trim();
            String vistas     = campos[9].trim();

            if (anio.isEmpty() || puntuacion.isEmpty()) return;

            try {
                Integer.parseInt(anio);
                Double.parseDouble(puntuacion);
                long v = vistas.isEmpty() ? 0L : Long.parseLong(vistas);

                anioKey.set(anio);
                datoVal.set(tipo + "|" + puntuacion + "|" + v);
                contexto.write(anioKey, datoVal);
            } catch (NumberFormatException e) {
                // Ignorar filas con datos invalidos
            }
        }
    }

    // --------------------------------------------------------
    // REDUCER: Agrega estadísticas por año
    // --------------------------------------------------------
    public static class AnioReducer
            extends Reducer<Text, Text, Text, Text> {

        @Override
        public void reduce(Text clave, Iterable<Text> valores, Context contexto)
                throws IOException, InterruptedException {

            int    totalTitulos = 0;
            int    peliculas    = 0;
            int    series       = 0;
            double sumaPunt     = 0.0;
            long   totalVistas  = 0L;

            for (Text val : valores) {
                String[] partes = val.toString().split("\\|");
                if (partes.length == 3) {
                    try {
                        String tipo  = partes[0].trim().toLowerCase();
                        double punt  = Double.parseDouble(partes[1]);
                        long   vista = Long.parseLong(partes[2]);

                        totalTitulos++;
                        sumaPunt    += punt;
                        totalVistas += vista;

                        if (tipo.equals("pelicula")) peliculas++;
                        else if (tipo.equals("serie")) series++;

                    } catch (NumberFormatException e) {
                        // Ignorar
                    }
                }
            }

            if (totalTitulos > 0) {
                double promPunt = sumaPunt / totalTitulos;
                String resultado = String.format(
                    "titulos=%d\tpeliculas=%d\tseries=%d\tpunt_prom=%.2f\tvistas_total=%d",
                    totalTitulos, peliculas, series, promPunt, totalVistas
                );
                contexto.write(clave, new Text(resultado));
            }
        }
    }

    // --------------------------------------------------------
    // DRIVER
    // --------------------------------------------------------
    public static void main(String[] args) throws Exception {

        if (args.length != 2) {
            System.err.println("Uso: TendenciasAnio <entrada_hdfs> <salida_hdfs>");
            System.exit(1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Tendencias de Produccion por Anio");

        job.setJarByClass(TendenciasAnio.class);
        job.setMapperClass(AnioMapper.class);
        job.setReducerClass(AnioReducer.class);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        boolean exito = job.waitForCompletion(true);
        System.exit(exito ? 0 : 1);
    }
}
