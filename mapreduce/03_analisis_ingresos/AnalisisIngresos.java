package analisis_ingresos;

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
 * JOB 03: ANALISIS DE INGRESOS POR DIRECTOR
 * Dataset: streaming_ampliado.csv
 *
 * Analisis: Para cada director calcula:
 *  - Total de recaudacion en USD
 *  - Numero de peliculas con datos financieros
 *  - Promedio de recaudacion por pelicula
 *  - ROI (recaudacion / presupuesto)
 *
 * Columnas CSV (indice):
 *   0:titulo, 1:tipo, 2:anio, 3:director,
 *   4:genero_1, 5:genero_2, 6:genero_3,
 *   7:idioma, 8:puntuacion, 9:vistas,
 *   10:duracion_min, 11:temporadas, 12:episodios,
 *   13:clasificacion, 14:pais,
 *   15:presupuesto_usd, 16:recaudacion_usd
 * ============================================================
 */
public class AnalisisIngresos {

    // --------------------------------------------------------
    // MAPPER: Emite (director, "presupuesto|recaudacion")
    // --------------------------------------------------------
    public static class DirectorMapper
            extends Mapper<LongWritable, Text, Text, Text> {

        private final Text directorKey = new Text();
        private final Text datosVal    = new Text();

        @Override
        public void map(LongWritable clave, Text valor, Context contexto)
                throws IOException, InterruptedException {

            String linea = valor.toString().trim();

            // Omitir cabecera
            if (linea.startsWith("titulo") || linea.isEmpty()) return;

            String[] campos = linea.split(",", -1);
            if (campos.length < 17) return;

            String director  = campos[3].trim();
            String presupStr = campos[15].trim();
            String recaudStr = campos[16].trim();

            // Solo procesar filas con recaudacion disponible
            if (director.isEmpty() || recaudStr.isEmpty()) return;

            try {
                long recaud = Long.parseLong(recaudStr);
                long presup = presupStr.isEmpty() ? 0L : Long.parseLong(presupStr);
                directorKey.set(director);
                datosVal.set(presup + "|" + recaud);
                contexto.write(directorKey, datosVal);
            } catch (NumberFormatException e) {
                // Ignorar filas con valores no numericos
            }
        }
    }

    // --------------------------------------------------------
    // REDUCER: Agrega datos financieros por director
    // --------------------------------------------------------
    public static class DirectorReducer
            extends Reducer<Text, Text, Text, Text> {

        @Override
        public void reduce(Text clave, Iterable<Text> valores, Context contexto)
                throws IOException, InterruptedException {

            long totalRecaud = 0L;
            long totalPresup = 0L;
            int  peliculas   = 0;
            long maxRecaud   = Long.MIN_VALUE;

            for (Text val : valores) {
                String[] partes = val.toString().split("\\|");
                if (partes.length == 2) {
                    try {
                        long presup = Long.parseLong(partes[0]);
                        long recaud = Long.parseLong(partes[1]);
                        totalPresup += presup;
                        totalRecaud += recaud;
                        peliculas++;
                        if (recaud > maxRecaud) maxRecaud = recaud;
                    } catch (NumberFormatException e) {
                        // Ignorar
                    }
                }
            }

            if (peliculas > 0) {
                long   promRecaud = totalRecaud / peliculas;
                double roi = totalPresup > 0
                        ? ((double) totalRecaud / totalPresup) : 0.0;

                String resultado = String.format(
                    "peliculas=%d\ttotal_recaud=%d\tpromedio=%d\troi=%.2f\tmax=%d",
                    peliculas, totalRecaud, promRecaud, roi, maxRecaud
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
            System.err.println("Uso: AnalisisIngresos <entrada_hdfs> <salida_hdfs>");
            System.exit(1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Analisis de Ingresos por Director");

        job.setJarByClass(AnalisisIngresos.class);
        job.setMapperClass(DirectorMapper.class);
        job.setReducerClass(DirectorReducer.class);

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
