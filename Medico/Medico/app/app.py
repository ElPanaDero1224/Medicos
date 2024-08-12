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
#Falta encriptar las contrasenias
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
#Falta un campo para agregar la cedula
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
            cedula = request.form.get('cedula')

            # Conectar a la base de datos e insertar los datos
            cursor = mysql.connection.cursor()
            # Llamar al procedimiento almacenado
            cursor.callproc('sp_RegistrarMedico', (nombre, apellidosp, apellidosm, correo, contrasenia, RFC, idrol, adminp, cedula))
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
#Actualizar Expedientes
@app.route('/ActualizarExpediente/<int:idExp>', methods=['GET', 'POST'])
def ActualizarExpediente(idExp):
    if 'id_medicos' not in session:
        return redirect(url_for('index'))

    cursor = mysql.connection.cursor()

#medicos obtenidos ADMIN
    if session.get('admin_permision') == 1:

        # Obtener los médicos (opcional)
        cursor.execute('SELECT id_medicos, CONCAT(nombres, " ", apellidos_p, " ", apellidos_m) AS nombre FROM medicos;')
        medicos = cursor.fetchall()

#Medicos obtenidos Normal USER
    else:
        query ='''
        SELECT id_medicos, CONCAT(nombres, " ", apellidos_p, " ", apellidos_m) 
        AS nombre FROM medicos
        WHERE id_medicos = %s;
        '''
        cursor.execute(query, (session['id_medicos'],))
        medicos = cursor.fetchall()

    # Obtener los datos del paciente por id_expediente
    cursor.execute('''
        SELECT id_expediente, nombres, apellidos_p, apellidos_m, alergias, enfermedades_cronicas, antecedentes_familiares, fecha_nacimiento, id_medico
        FROM expedientes WHERE id_expediente = %s
    ''', (idExp,))
    paciente = cursor.fetchone()

    if request.method == 'POST':
        # Obtener datos del formulario
        idmed = request.form['medico']
        nombre = request.form['nombre']
        apellidop = request.form['apellido_paterno']
        apellidom = request.form['apellido_materno']
        fecha = request.form['fecha_nacimiento']
        efc = request.form['enfermedad_cronica']
        aler = request.form['alergia']
        antecedentes_familiares = request.form['antecedentes_familiares']

        # Validar y actualizar datos
        try:
            fecha = datetime.strptime(fecha, '%Y-%m-%d').date()
        except ValueError:
            return "Formato de fecha no válido"

        cursor.execute('''
            UPDATE expedientes
            SET nombres=%s, apellidos_p=%s, apellidos_m=%s, alergias=%s, enfermedades_cronicas=%s, antecedentes_familiares=%s, fecha_nacimiento=%s, id_medico=%s
            WHERE id_expediente = %s
        ''', (nombre, apellidop, apellidom, aler, efc, antecedentes_familiares, fecha, idmed, idExp))
        mysql.connection.commit()
        cursor.close()

        if session.get('admin_permision') == 1:
            return redirect(url_for('Expedientes'))

        else:
            return redirect(url_for('Home'))

    return render_template('UpExpediente.html', medicos=medicos, paciente=paciente)

#--------------------------------------------------------------------------------------------------------





# --------------------------------------------------------------------------------------------------------
#Actualizar medicos
@app.route('/ActualizarMedico/<int:idMedico>', methods=['GET', 'POST'])
def ActualizarMedico(idMedico):
    if 'id_medicos' not in session:
        return redirect(url_for('index'))

    if session.get('admin_permision') != 1:
        return redirect(url_for('Home'))

    cursor = mysql.connection.cursor()

    query = '''
    SELECT id_medicos, nombres, apellidos_p, apellidos_m, correo, 
    RFC, cedula, id_rol, admin_permision 
    FROM medicos WHERE id_medicos = %s;
    '''
    cursor.execute(query, (idMedico,))
    medico = cursor.fetchone()
    cursor.close()

    cursor = mysql.connection.cursor()
    query = 'SELECT * FROM roles;'  # Cambié esto para seleccionar solo los campos necesarios
    cursor.execute(query)
    roles = cursor.fetchall()
    cursor.close()

    if request.method == 'POST':
        nombre = request.form['name']
        apellidop = request.form['apellido_paterno']
        apellidom = request.form['apellido_materno']
        correo = request.form['email']
        rfc = request.form['rfc']
        cedula = request.form['cedula']
        rol = request.form['rol']
        tipo_usuario = request.form['tipo_usuario']
        contrasenia = request.form['contrasenia']
        verificar_contrasenia = request.form['verificar_contrasenia']

        if contrasenia != verificar_contrasenia:
            flash('Las contraseñas no coinciden')
            return redirect(url_for('ActualizarMedico', idMedico=idMedico))

        # Encriptar la contraseña antes de guardarla (debes implementar la encriptación)

        cursor = mysql.connection.cursor()
        cursor.execute('''
            UPDATE medicos
            SET nombres=%s, apellidos_p=%s, apellidos_m=%s, correo=%s, 
                RFC=%s, cedula=%s, id_rol=%s, admin_permision=%s, contraseña=%s
            WHERE id_medicos = %s
        ''', (nombre, apellidop, apellidom, correo, rfc, cedula, rol, tipo_usuario, contrasenia, idMedico))
        mysql.connection.commit()
        cursor.close()

        return redirect(url_for('Home'))

    return render_template('UpMedico.html', medico=medico, roles=roles)


#--------------------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------------------
#Agregar cita completa
#Procedimiento almacenado para generar cita, expediente, receta

@app.route('/generarRecetas/<int:idExp>', methods=['GET', 'POST'])
def generarRecetas(idExp):
    if 'id_medicos' in session:
        id_medicos = session['id_medicos']
        if request.method == 'POST':
            try:
                cursor = mysql.connection.cursor()

                # Obtener los valores del formulario
                informacion = request.form.get('informacion')
                peso = request.form.get('peso')
                altura = request.form.get('altura')
                temperatura = request.form.get('temperatura')
                latidos_minuto = request.form.get('latidos_minuto')
                tratamiento = request.form.get('tratamiento')
                diagnostico = request.form.get('diagnostico')

                # Manejar conversiones con valores por defecto
                try:
                    peso = float(peso) if peso else None
                    altura = float(altura) if altura else None
                    temperatura = float(temperatura) if temperatura else None
                    latidos_minuto = int(latidos_minuto) if latidos_minuto else None
                except ValueError as e:
                    flash(f'Error en los valores decimales: {str(e)}', 'danger')
                    return redirect(url_for('generarRecetas', idExp=idExp))

                # Llamar al procedimiento almacenado
                cursor.callproc('sp_agregarReceta', (
                    tratamiento,
                    diagnostico,
                    idExp,
                    peso,
                    altura,
                    temperatura,
                    latidos_minuto,
                    id_medicos,
                    informacion
                ))

                # Confirmar la transacción
                mysql.connection.commit()
                cursor.close()

                # Redirección basada en permisos
                if session.get('admin_permision') == 1:
                    return redirect(url_for('Expedientes'))
                else:
                    return redirect(url_for('Home'))

            except Exception as e:
                mysql.connection.rollback()
                cursor.close()
                flash(f'Error al generar la receta: {str(e)}', 'danger')
                return redirect(url_for('generarRecetas', idExp=idExp))


        else:
            # Obtener datos del paciente
            cursor = mysql.connection.cursor()
            query_paciente = '''
            SELECT id_expediente, nombres, concat(apellidos_p, ' ', apellidos_m) as ap,
            alergias, enfermedades_cronicas, antecedentes_familiares, fecha_nacimiento
            FROM expedientes
            WHERE id_expediente = %s
            '''
            cursor.execute(query_paciente, (idExp,))
            paciente = cursor.fetchone()

            # Obtener datos del médico
            query_medico = '''
            SELECT id_medicos, m.nombres, concat(m.apellidos_p, ' ', m.apellidos_m) as ap, r.nombre_rol
            FROM medicos as m
            JOIN roles as r on m.id_rol = r.id_rol
            WHERE id_medicos = %s;
            '''
            cursor.execute(query_medico, (id_medicos,))
            medicos = cursor.fetchone()
            cursor.close()

            # Renderizar la plantilla
            return render_template('GenerarReceta.html', medicos=medicos, paciente=paciente)

    else:
        return redirect(url_for('index'))


#--------------------------------------------------------------------------------------------------------


@app.route('/mostrarReceta/<int:idRece>', methods=['GET', 'POST'])
def mostrarReceta(idRece):
    if 'id_medicos' in session:
        id_medicos = session['id_medicos']

        cursor = mysql.connection.cursor()

        query = '''
        SELECT ex.nombres, concat(ex.apellidos_p, ' ', ex.apellidos_m) as ap,
        ex.alergias, ex.enfermedades_cronicas, ex.antecedentes_familiares, ex.fecha_nacimiento,
        r.informacion, d.tratamiento, d.fecha, d.dx,
        c.fecha, e.peso, e.altura, e.temperatura, e.latidos_por_min,
        r.id_receta, r.id_diagnostico, r.id_cita, e.id_exploracion
        FROM expedientes as ex 
        JOIN recetas as r ON  ex.id_receta = r.id_receta
        JOIN diagnosticos as d on d.id_diagnostico = r.id_diagnostico
        JOIN citas AS c ON c.id_cita = r.id_cita
        JOIN exploraciones as e on e.id_exploracion = c.id_exploracion
        WHERE r.id_receta = %s
        '''

        cursor.execute(query, (idRece,))
        recetas = cursor.fetchall()

        query_medico = '''
        SELECT id_medicos, m.nombres, concat(m.apellidos_p, ' ', m.apellidos_m) as ap, r.nombre_rol
        FROM medicos as m
        JOIN roles as r on m.id_rol = r.id_rol
        WHERE id_medicos = %s;
        '''
        cursor.execute(query_medico, (id_medicos,))
        medicos = cursor.fetchone()
        cursor.close()

        return render_template('mostrarReceta.html', medicos=medicos, recetas=recetas)

    else:
        return redirect(url_for('index'))


#--------------------------------------------------------------------------------------------------------














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
