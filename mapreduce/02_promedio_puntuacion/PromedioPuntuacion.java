package promedio_puntuacion;

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
 * JOB 02: PROMEDIO DE PUNTUACION POR PAIS
 * Dataset: streaming_ampliado.csv
 *
 * Analisis: Calcula la puntuacion promedio del contenido
 * producido por cada pais.
 *
 * Columnas CSV:
 *   0:titulo, 1:tipo, 2:anio, 3:director,
 *   4:genero_1, 5:genero_2, 6:genero_3,
 *   7:idioma, 8:puntuacion, 9:vistas,
 *   10:duracion_min, 11:temporadas, 12:episodios,
 *   13:clasificacion, 14:pais, ...
 * ============================================================
 */
public class PromedioPuntuacion {

    // --------------------------------------------------------
    // MAPPER: Emite (pais, puntuacion)
    // --------------------------------------------------------
    public static class PaisMapper
            extends Mapper<LongWritable, Text, Text, Text> {

        private final Text paisKey  = new Text();
        private final Text puntoVal = new Text();

        @Override
        public void map(LongWritable clave, Text valor, Context contexto)
                throws IOException, InterruptedException {

            String linea = valor.toString().trim();

            // Omitir cabecera
            if (linea.startsWith("titulo") || linea.isEmpty()) return;

            String[] campos = linea.split(",", -1);
            if (campos.length < 15) return;

            String pais       = campos[14].trim();
            String puntuacion = campos[8].trim();

            if (pais.isEmpty() || puntuacion.isEmpty()) return;

            try {
                Double.parseDouble(puntuacion); // Validar que es numero
                paisKey.set(pais);
                puntoVal.set(puntuacion);
                contexto.write(paisKey, puntoVal);
            } catch (NumberFormatException e) {
                // Ignorar filas con puntuacion invalida
            }
        }
    }

    // --------------------------------------------------------
    // REDUCER: Calcula suma y conteo -> promedio por pais
    // --------------------------------------------------------
    public static class PaisReducer
            extends Reducer<Text, Text, Text, Text> {

        @Override
        public void reduce(Text clave, Iterable<Text> valores, Context contexto)
                throws IOException, InterruptedException {

            double suma  = 0.0;
            int    count = 0;
            double min   = Double.MAX_VALUE;
            double max   = -Double.MAX_VALUE;

            for (Text val : valores) {
                try {
                    double p = Double.parseDouble(val.toString());
                    suma += p;
                    count++;
                    if (p < min) min = p;
                    if (p > max) max = p;
                } catch (NumberFormatException e) {
                    // Ignorar
                }
            }

            if (count > 0) {
                double promedio = suma / count;
                String resultado = String.format(
                    "promedio=%.2f\ttitulos=%d\tmin=%.1f\tmax=%.1f",
                    promedio, count, min, max
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
            System.err.println("Uso: PromedioPuntuacion <entrada_hdfs> <salida_hdfs>");
            System.exit(1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Promedio de Puntuacion por Pais");

        job.setJarByClass(PromedioPuntuacion.class);
        job.setMapperClass(PaisMapper.class);
        job.setReducerClass(PaisReducer.class);

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
