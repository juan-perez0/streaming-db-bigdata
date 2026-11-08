# Configuración de Apache Hadoop 3.x para la Práctica Big Data
## Plataforma de Streaming — Análisis con MapReduce

---

## 1. Requisitos del Sistema

| Componente | Versión Recomendada |
|------------|---------------------|
| Sistema Operativo | Ubuntu 22.04 LTS / WSL2 en Windows |
| Java JDK | 11 (OpenJDK) |
| Apache Hadoop | 3.3.6 |
| RAM mínima | 4 GB |
| Disco libre | 10 GB |

---

## 2. Instalación de Java y Hadoop

### 2.1 Instalar Java JDK 11

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y openjdk-11-jdk
java -version
# Debe mostrar: openjdk version "11.x.x"
```

### 2.2 Descargar e instalar Hadoop 3.3.6

```bash
cd /tmp
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xzf hadoop-3.3.6.tar.gz
sudo mv hadoop-3.3.6 /opt/hadoop
```

### 2.3 Configurar variables de entorno

Agregar al archivo `~/.bashrc`:

```bash
# Java
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
# Hadoop
export HADOOP_HOME=/opt/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$JAVA_HOME/bin
```

Aplicar cambios:
```bash
source ~/.bashrc
hadoop version
# Debe mostrar: Hadoop 3.3.6
```

---

## 3. Archivos de Configuración de Hadoop

Los archivos se encuentran en `$HADOOP_HOME/etc/hadoop/`

### 3.1 hadoop-env.sh

```bash
# Editar: $HADOOP_HOME/etc/hadoop/hadoop-env.sh
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

### 3.2 core-site.xml

```xml
<!-- $HADOOP_HOME/etc/hadoop/core-site.xml -->
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
    <description>URI del sistema de archivos HDFS</description>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/opt/hadoop/tmp</value>
    <description>Directorio temporal de Hadoop</description>
  </property>
</configuration>
```

### 3.3 hdfs-site.xml

```xml
<!-- $HADOOP_HOME/etc/hadoop/hdfs-site.xml -->
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
    <description>Factor de replicación (1 para modo pseudo-distribuido)</description>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:///opt/hadoop/data/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:///opt/hadoop/data/datanode</value>
  </property>
  <property>
    <name>dfs.blocksize</name>
    <value>134217728</value>
    <description>Tamaño de bloque HDFS: 128 MB</description>
  </property>
</configuration>
```

### 3.4 mapred-site.xml

```xml
<!-- $HADOOP_HOME/etc/hadoop/mapred-site.xml -->
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
    <description>Framework de ejecución: YARN</description>
  </property>
  <property>
    <name>mapreduce.map.memory.mb</name>
    <value>512</value>
  </property>
  <property>
    <name>mapreduce.reduce.memory.mb</name>
    <value>512</value>
  </property>
  <property>
    <name>mapreduce.application.classpath</name>
    <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*,
           $HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
  </property>
</configuration>
```

### 3.5 yarn-site.xml

```xml
<!-- $HADOOP_HOME/etc/hadoop/yarn-site.xml -->
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.env-whitelist</name>
    <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,
           HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,
           HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
  </property>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>localhost</value>
  </property>
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>2048</value>
    <description>Memoria máxima para contenedores YARN</description>
  </property>
</configuration>
```

---

## 4. Inicialización del Sistema HDFS

```bash
# Crear directorios necesarios
mkdir -p /opt/hadoop/data/namenode
mkdir -p /opt/hadoop/data/datanode
mkdir -p /opt/hadoop/tmp

# Configurar SSH sin contraseña (requerido por Hadoop)
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Verificar conexión SSH local
ssh localhost "echo Conexion SSH exitosa"

# Formatear el NameNode (solo la primera vez)
hdfs namenode -format
```

---

## 5. Iniciar y Detener Servicios

```bash
# Iniciar HDFS
start-dfs.sh

# Iniciar YARN
start-yarn.sh

# Verificar servicios activos
jps
# Salida esperada:
# NameNode
# DataNode
# SecondaryNameNode
# ResourceManager
# NodeManager

# Detener todos los servicios
stop-yarn.sh
stop-dfs.sh
```

---

## 6. Interfaces Web de Hadoop

| Interfaz | URL | Descripción |
|----------|-----|-------------|
| NameNode (HDFS) | http://localhost:9870 | Estado del sistema de archivos |
| ResourceManager (YARN) | http://localhost:8088 | Monitoreo de Jobs |
| Node Manager | http://localhost:8042 | Estado del nodo |
| Job History Server | http://localhost:19888 | Historial de Jobs |

---

## 7. Verificación del Entorno

```bash
# Crear directorio de usuario en HDFS
hdfs dfs -mkdir -p /user/$USER

# Verificar que HDFS está operativo
hdfs dfs -ls /

# Verificar YARN
yarn node -list
```

---

## 8. Solución de Problemas Comunes

### Error: "Connection refused" al iniciar Hadoop
```bash
# Verificar que SSH está activo
sudo service ssh start
# Verificar variables de entorno
echo $HADOOP_HOME
echo $JAVA_HOME
```

### Error: NameNode no formateado
```bash
# Detener servicios primero
stop-dfs.sh
# Re-formatear (elimina datos existentes)
hdfs namenode -format
# Reiniciar
start-dfs.sh
```

### Error: "Safe mode is ON"
```bash
# Esperar a que salga automáticamente o forzar:
hdfs dfsadmin -safemode leave
```

### Error de memoria en Jobs MapReduce
```bash
# Aumentar heap de MapReduce
export HADOOP_HEAPSIZE=512
export MAPRED_CHILD_JAVA_OPTS="-Xmx512m"
```
