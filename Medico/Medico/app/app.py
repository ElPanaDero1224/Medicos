from flask import Flask, render_template, request, flash, redirect, session, url_for, jsonify, send_file
from flask_mysqldb import MySQL


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



#--------------------------------------------------------------------------------------------------------
#<Routa de inicio de sesion>
@app.route('/')
def index():
    return render_template('index.html')
#--------------------------------------------------------------------------------------------------------

@app.route('/iniciar_Sesion', methods=['POST'])
def iniciar_Sesion():
    if request.method == 'POST':
        cursor = mysql.connection.cursor()
        rfc = request.form.get('rfc')
        password = request.form.get('password')

        query = '''
        SELECT id_medicos FROM medicos 
        WHERE RFC = %s AND contraseña = %s;
        '''

        cursor.execute(query, (rfc, password))
        result = cursor.fetchone()
        cursor.close()

        if result:
            id_medicos = result[0]
            session['id_medicos'] = id_medicos
            return redirect(url_for('Home'))
        else:
            # Manejo de error si no se encuentra el médico
            return 'Credenciales incorrectas', 401


@app.route('/Home', methods=['GET'])
def Home():
    if session:
        return render_template('Home.html', id_medicos=session['id_medicos'])
    else:
        return redirect(url_for('iniciar_Sesion'))





if __name__ == '__main__':
    app.run(port=3000, debug=True)
