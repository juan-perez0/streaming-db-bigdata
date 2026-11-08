package conteo_genero;

import java.io.IOException;
import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/**
 * ============================================================
 * JOB 01: CONTEO DE CONTENIDO POR GÉNERO
 * Dataset: streaming_ampliado.csv
 * 
 * Análisis: Cuenta cuántos títulos pertenecen a cada género.
 * El dataset tiene hasta 3 géneros por fila (genero_1, genero_2, genero_3).
 * 
 * Columnas CSV:
 *   0:titulo, 1:tipo, 2:anio, 3:director,
 *   4:genero_1, 5:genero_2, 6:genero_3,
 *   7:idioma, 8:puntuacion, 9:vistas, ...
 * ============================================================
 */
public class ConteoGenero {

    // --------------------------------------------------------
    // MAPPER: Lee cada línea del CSV y emite (género, 1)
    // --------------------------------------------------------
    public static class GeneroMapper
            extends Mapper<LongWritable, Text, Text, IntWritable> {

        private static final IntWritable UNO = new IntWritable(1);
        private final Text generoKey = new Text();

        @Override
        public void map(LongWritable clave, Text valor, Context contexto)
                throws IOException, InterruptedException {

            String linea = valor.toString().trim();

            // Omitir cabecera del CSV
            if (linea.startsWith("titulo") || linea.isEmpty()) {
                return;
            }

            // Separar campos por coma
            String[] campos = linea.split(",", -1);

            if (campos.length < 7) return; // Fila incompleta

            // Índices de los géneros: 4, 5, 6
            int[] indicesGenero = {4, 5, 6};

            for (int idx : indicesGenero) {
                String genero = campos[idx].trim();
                // Emitir solo si el campo no está vacío
                if (!genero.isEmpty()) {
                    generoKey.set(genero);
                    contexto.write(generoKey, UNO);
                }
            }
        }
    }

    // --------------------------------------------------------
    // REDUCER: Suma todos los "1" recibidos por cada género
    // --------------------------------------------------------
    public static class GeneroReducer
            extends Reducer<Text, IntWritable, Text, IntWritable> {

        private final IntWritable resultado = new IntWritable();

        @Override
        public void reduce(Text clave, Iterable<IntWritable> valores, Context contexto)
                throws IOException, InterruptedException {

            int suma = 0;
            for (IntWritable val : valores) {
                suma += val.get();
            }
            resultado.set(suma);
            contexto.write(clave, resultado);
        }
    }

    // --------------------------------------------------------
    // DRIVER: Configura y lanza el Job de MapReduce
    // --------------------------------------------------------
    public static void main(String[] args) throws Exception {

        if (args.length != 2) {
            System.err.println("Uso: ConteoGenero <ruta_entrada_hdfs> <ruta_salida_hdfs>");
            System.exit(1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Conteo de Contenido por Género");

        job.setJarByClass(ConteoGenero.class);

        // Clases Mapper y Reducer
        job.setMapperClass(GeneroMapper.class);
        job.setCombinerClass(GeneroReducer.class); // Combiner local para optimizar
        job.setReducerClass(GeneroReducer.class);

        // Tipos de salida
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        // Rutas de entrada y salida en HDFS
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        // Ejecutar y esperar resultado
        boolean exito = job.waitForCompletion(true);
        System.exit(exito ? 0 : 1);
    }
}
