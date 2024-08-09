from flask import Flask, render_template, request, flash, redirect, session, url_for, jsonify, send_file
from flask_mysqldb import MySQL
import MySQLdb.cursors

app = Flask(__name__)

# Configuración de la conexión a MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Es_el_de_halo_5'
app.config['MYSQL_DB'] = 'medicos'

app.secret_key='mysecretkey'

mysql = MySQL(app)

if mysql:
    print('Conexion establecida')

else:
    print('No hay conexion')

cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)


#--------------------------------------------------------------------------------------------------------
#<Routa de inicio de sesion>
@app.route('/')
def index():
    return render_template('index.html')
#--------------------------------------------------------------------------------------------------------

@app.route('/iniciar_Sesion', methods=['POST'])
def iniciar_Sesion():
    if request.method == 'POST':

        rfc = request.form.get('rfc')
        password = request.form.get('password')

        query = '''
        select id_medicos FROM medicos 
        WHERE RFC = ? AND contraseña = ?;    
                    '''
        cursor.execute(query, (rfc, password))

        id = cursor.fetchone()
        session['id_medicos'] = id
        return redirect(url_for('iniciar_Sesion'))




if __name__ == '__main__':
    app.run(port=3000, debug=True)
