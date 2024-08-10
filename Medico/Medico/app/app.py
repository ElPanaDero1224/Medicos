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




#--------------------------------------------------------------------------------------------------------
#iniciar
#Faltan alertas por si el usuario no puede redireccionar
#Tambien falta agregar una forma de que el medio muestre si es un administrador o no
@app.route('/iniciar_Sesion', methods=['POST'])
def iniciar_Sesion():
    if request.method == 'POST':
        cursor = mysql.connection.cursor()
        rfc = request.form.get('rfc')
        password = request.form.get('password')

        query = '''
        SELECT id_medicos, admin_permision FROM medicos 
        WHERE RFC = %s AND contraseña = %s;
        '''

        cursor.execute(query, (rfc, password))
        result = cursor.fetchone()

        if result:
            id_medicos, admin_permision = result
            session['id_medicos'] = id_medicos
            session['admin_permision'] = admin_permision
            return redirect(url_for('Home'))
        else:
            # Manejo de error si no se encuentra el médico
            return 'Credenciales incorrectas', 401
#--------------------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------------------
#Ruta para redirigir al inicio con los pacientes de cada medico al inicio
@app.route('/Home', methods=['GET'])
def Home():
    if 'id_medicos' in session:
        #para los admin
        if session.get('admin_permision'):
            id_medicos = session['id_medicos']
            cursor = mysql.connection.cursor()
            cursor.execute('SELECT * FROM vw_medicos')
            medicos = cursor.fetchall()
            return render_template('Home.html', id_medicos=id_medicos, medicos = medicos)
            pass
        #para el usuario comun
        else:
            id_medicos = session['id_medicos']
            cursor = mysql.connection.cursor()
            query = 'SELECT * FROM vw_pacientes WHERE id_medico = %s;'
            cursor.execute(query, (id_medicos,))
            pacientes = cursor.fetchall()
            cursor.close()

            return render_template('Home.html', id_medicos=id_medicos, pacientes=pacientes)

    return redirect(url_for('index'))

#--------------------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------------------
#Funcion dos en uno
@app.route('/AgregarMedicos', methods=['GET', 'POST'])
def AgregarMedicos():
    if request.method == 'POST':
        # Recoger los datos del formulario
        rfc = request.form.get('rfc')
        nombre = request.form.get('name')
        email = request.form.get('email')
        cedula = request.form.get('cedula')
        rol_id = request.form.get('rol')

        # Conectar a la base de datos e insertar los datos
        cursor = mysql.connection.cursor()
        query = '''
            INSERT INTO medicos (RFC, nombres, correo, cedula, id_rol)
            VALUES (%s, %s, %s, %s, %s);
        '''
        cursor.execute(query, (rfc, nombre, email, cedula, rol_id))
        mysql.connection.commit()
        cursor.close()

        # Redirigir a la página de médicos después de agregar
        return redirect(url_for('gMedicos'))

    # En caso de que la solicitud sea GET, mostrar el formulario
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT * FROM roles;')
    roles = cursor.fetchall()
    cursor.close()
    return render_template('gMedicos.html', roles=roles)
#--------------------------------------------------------------------------------------------------------
#cerrar sesion
@app.route('/cerrar_sesion', methods=['POST'])
def cerrar_sesion():
    # Eliminar la variable de sesión
    session.pop('id_medicos', None)
    # Redirigir a la página de inicio
    return redirect(url_for('index'))
#--------------------------------------------------------------------------------------------------------








if __name__ == '__main__':
    app.run(port=3000, debug=True)
