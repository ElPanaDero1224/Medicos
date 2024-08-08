from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL
import MySQLdb.cursors

app = Flask(__name__)

# Configuración de la conexión a MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'tu_password'
app.config['MYSQL_DB'] = 'flask_db'

# Inicialización de MySQL
mysql = MySQL(app)

# Verificación de la conexión a la base de datos
try:
    # Intentamos establecer la conexión
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT 1')  # Simple consulta para verificar la conexión
    connection_status = "Conectado a la base de datos MySQL"
except MySQLdb.Error as e:
    connection_status = f"No se pudo conectar a la base de datos MySQL: {e}"

@app.route('/')
def index():
    return connection_status

if __name__ == '__main__':
    app.run(debug=True)
