from flask import Flask, render_template, request, flash, redirect, session, url_for, jsonify, send_file
from flask_mysqldb import MySQL
from datetime import datetime


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
        if session.get('admin_permision') == 1:
            id_medicos = session['id_medicos']
            cursor = mysql.connection.cursor()
            cursor.execute('SELECT * FROM vw_medicos')
            medicos = cursor.fetchall()
            return render_template('HomeAdmin.html', id_medicos=id_medicos, medicos = medicos)
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
#Funcion dos en uno Agregar un medico y abrir la plantilla para ingresar un medico
#Falta agregar lo de verificar contrasenia, no repetir RFC
@app.route('/AgregarMedicos', methods=['GET', 'POST'])
def AgregarMedicos():
    if session.get('admin_permision') == 1 and 'id_medicos' in session:
        if request.method == 'POST':
            nombre = request.form.get('name')
            apellidosp = request.form.get('apellido_paterno')
            apellidosm = request.form.get('apellido_materno')
            correo = request.form.get('email')
            contrasenia = request.form.get('contrasenia')
            RFC = request.form.get('rfc')
            idrol = request.form.get('rol')
            adminp = request.form.get('tipo_usuario')

            # Conectar a la base de datos e insertar los datos
            cursor = mysql.connection.cursor()
            # Llamar al procedimiento almacenado
            cursor.callproc('sp_RegistrarMedico', (nombre, apellidosp, apellidosm, correo, contrasenia, RFC, idrol, adminp))
            # Confirmar la transacción
            mysql.connection.commit()
            # Cerrar el cursor
            cursor.close()

            return redirect(url_for('Home'))


        # En caso de que la solicitud sea GET, mostrar el formulario
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM roles;')
        roles = cursor.fetchall()
        cursor.close()
        return render_template('gMedicos.html', roles=roles)

    elif 'id_medicos' in session:
        return redirect(url_for('Home'))


    else:
        return redirect(url_for('index'))
#--------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------
#Ruta para mostrar los expedientes siendo admin
@app.route('/Expedientes', methods=['POST', 'GET'])
def Expedientes():
    if session.get('admin_permision') == 1 and 'id_medicos' in session:
        id_medicos = session['id_medicos']
        cursor = mysql.connection.cursor()
        query = 'SELECT * FROM vw_pacientes;'
        cursor.execute(query)
        pacientes = cursor.fetchall()
        cursor.close()

        return render_template('expedientesAd.html', id_medicos=id_medicos, pacientes=pacientes)
    else:
        return redirect(url_for('Home'))


#--------------------------------------------------------------------------------------------------------








# --------------------------------------------------------------------------------------------------------
# Funcion dos en uno
@app.route('/AgregarPaciente', methods=['GET', 'POST'])
def AgregarPaciente():
    if 'id_medicos' not in session:
        return redirect(url_for('index'))

    cursor = mysql.connection.cursor()

    if session.get('admin_permision') == 1:
        # Caso de administrador: Obtener todos los médicos
        query = '''SELECT id_medicos, CONCAT(nombres, ' ', apellidos_p, ' ', apellidos_m) as nombre FROM medicos;'''
        cursor.execute(query)
    else:
        # Caso de médico normal: Obtener solo el médico específico
        query = '''SELECT id_medicos, CONCAT(nombres, ' ', apellidos_p, ' ', apellidos_m) as nombre FROM medicos WHERE id_medicos = %s;'''
        cursor.execute(query, (session['id_medicos'],))

    medicos = cursor.fetchall()
    cursor.close()

    if request.method == 'POST':
        idmed = request.form.get('medico')
        nombre = request.form.get('nombre')
        apellidop = request.form.get('apellido_paterno')
        apellidosm = request.form.get('apellido_materno')
        fecha = request.form.get('fecha_nacimiento')
        efc = request.form.get('enfermedad_cronica')
        aler = request.form.get('alergia')
        antecedentes_familiares = request.form.get('antecedentes_familiares')
        # Convertir la fecha a formato DATE
        # Asegúrate de que 'fecha' esté en formato 'YYYY-MM-DD'
        # Puedes utilizar la librería datetime si es necesario
        try:
            fecha = datetime.strptime(fecha, '%Y-%m-%d').date()
        except ValueError:
            # Manejo de errores si la fecha no tiene el formato correcto
            return "Formato de fecha no válido"
        # Ejecutar el procedimiento almacenado
        cursor = mysql.connection.cursor()
        # Llamada al procedimiento almacenado
        cursor.callproc('sp_ingresarExpediente', [
            nombre,
            apellidop,
            apellidosm,
            aler,
            efc,
            antecedentes_familiares,
            fecha,
            idmed,
            None  # Puedes pasar un valor o 'None' si id_receta no es obligatorio
        ])
        # Confirmar los cambios
        mysql.connection.commit()
        # Cerrar el cursor
        cursor.close()
        return redirect('Home')

        pass

    return render_template('gPaciente.html', medicos=medicos)


# --------------------------------------------------------------------------------------------------------


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
