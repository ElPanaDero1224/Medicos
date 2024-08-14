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
#no es necesario modificarlo
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
#no es necesario modificarlo
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
#Ya se muestra en logs #########
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
            #id del medico para el logs
            cursor.execute('SET @id_medico = %s', ( session['id_medicos'],))
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
#Ya se agrega en logs
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
        cursor.execute('SET @id_medico = %s', (session['id_medicos'],))
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
#Ya se actualiza logs
@app.route('/ActualizarExpediente/<int:idExp>', methods=['GET', 'POST'])
def ActualizarExpediente(idExp):
    if 'id_medicos' not in session:
        return redirect(url_for('index'))

    cursor = mysql.connection.cursor()
    cursor.execute('SET @id_medico = %s', (session['id_medicos'],))

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
#Ya se realiza logs
@app.route('/ActualizarMedico/<int:idMedico>', methods=['GET', 'POST'])
def ActualizarMedico(idMedico):
    if 'id_medicos' not in session:
        return redirect(url_for('index'))

    if session.get('admin_permision') != 1:
        return redirect(url_for('Home'))

    cursor = mysql.connection.cursor()

    cursor.execute('SET @id_medico = %s', (session['id_medicos'],))
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
        cursor.execute('SET @id_medico = %s', (session['id_medicos'],))
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
#Ya implementa logs

@app.route('/generarRecetas/<int:idExp>', methods=['GET', 'POST'])
def generarRecetas(idExp):
    if 'id_medicos' in session:
        id_medicos = session['id_medicos']
        if request.method == 'POST':
            try:
                cursor = mysql.connection.cursor()
                cursor.execute('SET @id_medico = %s', (session['id_medicos'],))

                # Obtener los valores del formulario
                informacion = request.form.get('informacion')
                peso = request.form.get('peso')
                altura = request.form.get('altura')
                temperatura = request.form.get('temperatura')
                latidos_minuto = request.form.get('latidos_minuto')
                tratamiento = request.form.get('tratamiento')
                diagnostico = request.form.get('diagnostico')

                # Manejar conversiones con valores por defecto

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
#Actualizar diagnostico

@app.route('/actualizarDiagnostico/<int:idReceta>', methods=['GET', 'POST'])
def actualizarDiagnosticos(idReceta):
    if 'id_medicos' in session:
        cursor = mysql.connection.cursor()

        # Consulta para obtener la receta y el diagnóstico actual
        query = '''
        SELECT r.id_receta, r.id_diagnostico, d.tratamiento, d.fecha, d.dx
        FROM recetas as r
        JOIN diagnosticos as d ON d.id_diagnostico = r.id_diagnostico
        WHERE r.id_receta = %s
        '''
        cursor.execute(query, (idReceta,))
        rediag = cursor.fetchone()
        cursor.close()

        return render_template('UpDiagnostico.html', rediag=rediag)

    else:
        return redirect(url_for('index'))


#--------------------------------------------------------------------------------------------------------
#Funcion para actualizar diagnostico
@app.route('/updateDiagnostico/<int:idDiag>', methods=['GET', 'POST'])
def updateDiagnostico(idDiag):
    if 'id_medicos' in session:
        cursor = mysql.connection.cursor()
        cursor.execute('SET @id_medico = %s', (session['id_medicos'],))
        if request.method == 'POST':
            tratamiento = request.form['tratamiento']
            dx = request.form['diagnostico']

            # Consulta para actualizar el diagnóstico
            query = '''
                    UPDATE diagnosticos 
                    SET tratamiento = %s, dx = %s 
                    WHERE id_diagnostico = %s
                    '''
            cursor.execute(query, (tratamiento, dx, idDiag))
            mysql.connection.commit()  # Confirma la transacción

            return redirect(url_for('Home'))  # Asegúrate de que 'Home' sea una ruta válida

    return redirect(url_for('index'))
#--------------------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------------------
@app.route('/actualizarExploraciones/<int:idReceta>', methods=['GET', 'POST'])
def actualizarExploraciones(idReceta):
    if 'id_medicos' in session:
        cursor = mysql.connection.cursor()

        # Consulta para obtener la receta y la exploracion actual
        query = '''
         SELECT r.id_receta, e.id_exploracion, e.peso, 
        e.altura, e.temperatura, e.latidos_por_min 
        FROM recetas as r
        JOIN citas as c on c.id_exploracion = r.id_cita
        JOIN exploraciones as e on e.id_exploracion = c.id_exploracion
        WHERE r.id_receta = %s
        '''
        cursor.execute(query, (idReceta,))
        rediag = cursor.fetchone()
        cursor.close()

        return render_template('UpExploraciones.html', rediag=rediag)

    else:
        return redirect(url_for('index'))





#-------------------------------------------------------------------------------------------------




#Funcion para actualizar exploraciones
@app.route('/updateExploraciones/<int:idExplo>', methods=['GET', 'POST'])
def updateExploraciones(idExplo):
    if 'id_medicos' in session:
        cursor = mysql.connection.cursor()
        cursor.execute('SET @id_medico = %s', (session['id_medicos'],))
        if request.method == 'POST':
            peso = request.form['peso']
            altura = request.form['altura']
            temperatura = request.form['temperatura']
            latidos_minuto = request.form['latidos_minuto']


            # Consulta para actualizar el diagnóstico
            query = '''
                    UPDATE exploraciones SET peso = %s, 
                    altura = %s, temperatura = %s, 
                    latidos_por_min = %s WHERE id_exploracion = %s
                    '''
            cursor.execute(query, (peso, altura, temperatura, latidos_minuto, idExplo,))
            mysql.connection.commit()  # Confirma la transacción

            return redirect(url_for('Home'))  # Asegúrate de que 'Home' sea una ruta válida

    return redirect(url_for('index'))
#--------------------------------------------------------------------------------------------------------






#--------------------------------------------------------------------------------------------------------
#Actualizar receta

@app.route('/actualizarReceta/<int:idReceta>', methods=['GET', 'POST'])
def actualizarReceta(idReceta):
    if 'id_medicos' in session:
        cursor = mysql.connection.cursor()

        # Consulta para obtener la receta y el diagnóstico actual
        query = '''
        SELECT id_receta, informacion FROM recetas
        WHERE id_receta = %s
        '''
        cursor.execute(query, (idReceta,))
        rediag = cursor.fetchone()
        cursor.close()

        return render_template('UpReceta.html', rediag=rediag)

    else:
        return redirect(url_for('index'))
#--------------------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------------------
#Funcion para actualizar receta
@app.route('/updateReceta/<int:idReceta>', methods=['GET', 'POST'])
def updateReceta(idReceta):
    if 'id_medicos' in session:
        cursor = mysql.connection.cursor()
        cursor.execute('SET @id_medico = %s', (session['id_medicos'],))
        if request.method == 'POST':
            informacion = request.form['informacion']

            # Consulta para actualizar la información de la receta
            query = '''
                UPDATE recetas 
                SET informacion = %s 
                WHERE id_receta = %s;
            '''
            cursor.execute(query, (informacion, idReceta))
            mysql.connection.commit()
            cursor.close()

            return redirect(url_for('Home'))  # Asegúrate de que 'Home' sea una ruta válida

    # Redirige a la página de inicio de sesión si no hay sesión activa
    return redirect(url_for('index'))


#--------------------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------------------
#borrar medico
#Ya tiene funcion de logs
@app.route('/borrar_medico/<int:idMedico>', methods=['GET', 'POST'])
def borrar_medico(idMedico):
    if 'id_medicos' in session and session.get('admin_permision') == 1:  # Verifica si hay sesión y permisos
        if idMedico == session['id_medicos']:  # Verifica si el ID del médico es el mismo que el ID del usuario
            flash('No puedes eliminar tu propia cuenta', 'danger')  # Mensaje de error
            return redirect(url_for('Home'))  # Redirige al panel principal
        try:
            cursor = mysql.connection.cursor()
            cursor.execute('SET @id_medico = %s', (session['id_medicos'],))
            cursor.callproc('sp_borrarMedico', [idMedico])
            mysql.connection.commit()
            cursor.close()
            flash('El médico ha sido eliminado correctamente', 'success')
        except Exception as e:
            mysql.connection.rollback()
            cursor.close()
            flash(f'Error al eliminar el médico: {str(e)}', 'danger')  # Mensaje de error en caso de excepción
        return redirect(url_for('Home'))
    else:
        return redirect(url_for('index'))  # Redirige al inicio si no hay permisos

#--------------------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------------------
@app.route('/borrarExpediente/<int:idExp>', methods=['GET', 'POST'])
def borrarExpediente(idExp):
    if 'id_medicos' in session:
        try:
            idMed = session['id_medicos']
            cursor = mysql.connection.cursor()
            cursor.execute('SET @id_medico = %s', (idMed,))
            cursor.callproc('borrarExpedientes', [idExp])
            mysql.connection.commit()
            cursor.close()

        except Exception as e:
            mysql.connection.rollback()  # Deshace la transacción en caso de error
            flash(f'Ocurrió un error al intentar eliminar el expediente: {str(e)}', 'danger')
        finally:
            cursor.close()

        if 'id_medicos' in session and session.get('admin_permision') == 1:
            return redirect(url_for('Expedientes'))

        else:
            return redirect(url_for('Home'))
    else:
        return redirect(url_for('index'))  # Redirige al inicio si no hay permisos

#--------------------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------------------
@app.route('/mostrarLogs', methods=['GET', 'POST'])
def mostrarLogs():
    if 'id_medicos' in session and session.get('admin_permision') == 1:

        cursor = mysql.connection.cursor()
        # Consulta para obtener los logs
        query = '''
        SELECT concat(m.nombres, ' ', m.apellidos_p, ' ', m.apellidos_m) as nombre,
        nombre_rol, admin_permision,
        accion, fecha
        FROM logs_acciones as l
        JOIN medicos as m on m.id_medicos = l.id_medico
        JOIN roles as r on m.id_rol = r.id_rol
        ORDER BY fecha DESC;;
        '''
        cursor.execute(query)
        rediag = cursor.fetchall()
        cursor.close()

        return render_template('mostrarLogs.html', rediag=rediag)

    else:
        return redirect(url_for('index'))











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
