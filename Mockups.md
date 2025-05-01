# 📱 Mockups Visuales - Aplicación de Investigación Operativa

Este documento contiene los diseños preliminares en estilo ASCII para las pantallas principales de la aplicación móvil de **Investigación Operativa**.

---

## 🧾 1. Pantalla de Login

```
+---------------------------------------------+
|          📘 INVESTIGACIÓN OPERATIVA         |
|---------------------------------------------+
|     [📧] Correo institucional              |
|     [🔒] Contraseña  Cell                   |
|                                             |
|     [ Iniciar Sesión ]                      |
|                                             |
|     ¿Olvidaste tu contraseña?               |
+---------------------------------------------+
```

---

## 🏠 2. Menú Principal (Rol: Administrador)

```
+---------------- MENÚ ADMIN ------------------+
|       👨‍💼 Bienvenido, [Nombre del Admin]      |
|----------------------------------------------|
|  📚  Gestión de Estudiantes                  |
|  ✏️  Cargar/Editar Ejercicios                |
|  📝  Configurar Examen                       |
|  📊  Ver Estadísticas                        |
|  🔐  Seguridad / Configuración avanzada      |
|                                              |
|        [Cerrar Sesión]                       |
+----------------------------------------------+
```

---

## 🏠 3. Menú Principal (Rol: Estudiante)

```
+---------------------------------------------+
|       🎓 Bienvenido, [Nombre Estudiante]   |
|---------------------------------------------|
|  📝  Rendir Examen                          |
|  📜  Historial de Calificaciones            |
|  🧠  Ver Modelos / Fórmulas de ayuda        |
|                                             |
|        [Cerrar Sesión]                      |
+---------------------------------------------+
```

---

## 🧪 4. Rendir Examen (Una Pregunta)

```
+---------------------------------------------+
| 🧾 Pregunta 1/3 - Tema: Programación Lineal  |
|---------------------------------------------|
| Enunciado:                                  |
| "Una empresa desea maximizar..."            |
|                                             |
| Modelo: [📐 Seleccionar modelo]              |
| Fórmula: [ fx = 3x + 2y ]                   |
| Respuesta: [ 500 ]                          |
|                                             |
|   [Anterior]        [Siguiente]             |
+---------------------------------------------+
```
o
```
+--------------------- EXAMEN ----------------+
| Pregunta 1 de 3                              |
|---------------------------------------------|
| Tema: Modelos de Transporte                 |
| Pregunta:                                   |
| "Plantea el modelo para..."                 |
|---------------------------------------------|
| Modelo a usar: [ ▼ Seleccionar Modelo ]     |
| Fórmula:        [ _____________________ ]   |
| Valor respuesta: [ ___________________ ]     |
|---------------------------------------------|
|  [ ← Anterior ]      [ Siguiente → ]        |
+---------------------------------------------+
```
---

## 📬 5. Resultado del Examen

```
+---------------------------------------------+
|              ✅ Examen Finalizado            |
|---------------------------------------------|
| Tu calificación: 78/100                     |
| Estado: APROBADO                            |
|                                             |
| [ 📧 Enviar calificación a tu correo   ]    |
| [ 🧾 Ver respuestas correctas          ]    |
|                                             |
|   [Volver al menú principal]                |
+---------------------------------------------+
```

---

## 📚 6. Gestión de Estudiantes (Administrador)

```
+---------------------------------------------+
|         📋 Lista de Estudiantes             |
|---------------------------------------------|
| 🔍 [Buscar estudiante...]                   |
|                                             |
| 1. Juan Pérez    | 📧 jperez@ucb.edu.bo     |
|    📱 76543210   | 🧪 [Editar notas]       |
|---------------------------------------------|
| 2. María López   | 📧 mlopez@ucb.edu.bo     |
|    📱 76432109   | 🧪 [Editar notas]       |
|---------------------------------------------|
|         [➕ Añadir nuevo estudiante]        |
+---------------------------------------------+
```

```

+-------------- ESTUDIANTES ------------------+
| Buscar: [ ______________________ ] 🔍        |
|---------------------------------------------|
| Nombre             | Celular | Nota 1 | ... |
|---------------------------------------------|
| Juan Pérez         | 71234567|   80   |     |
| Ana López          | 72345678|   95   |     |
| ...                | .....   | ...          |
|---------------------------------------------|
| [ ➕ Agregar estudiante ] [ ⚙️ Configurar notas ] |
+---------------------------------------------+
```
---

## 📓 7. Cargar/Editar Ejercicios

```
+---------------------------------------------+
|        ✍️ Base de Datos de Ejercicios       |
|---------------------------------------------|
| Tema: [Simulación]                          |
|                                             |
| 1. Enunciado: "Simule el siguiente sistema" |
|    Fórmula esperada: [ λ = 1 / E(t) ]       |
|    Respuesta: [ 0.25 ]                      |
|    [✏️ Editar] [🗑️ Eliminar]                |
|---------------------------------------------|
|     [➕ Añadir nuevo ejercicio]             |
+---------------------------------------------+
```
o
```

+------------- CARGAR EJERCICIOS -------------+
| Tema: [ ▼ Seleccionar o Crear nuevo ]       |
|---------------------------------------------|
| Pregunta:                                   |
| [ Escribe la pregunta aquí...           ]   |
| Fórmula esperada:                           |
| [ ________________________________     ]    |
| Respuesta correcta:                         |
| [ ________________________________     ]    |
|---------------------------------------------|
| [ ➕ Agregar pregunta ]   [ 💾 Guardar ]   |
| [ ⬅️ Volver ]                               |
+---------------------------------------------+


```

---

## 📈 8. Estadísticas

```
+---------------------------------------------+
|            📊 Estadísticas de Curso         |
|---------------------------------------------|
| Paralelo: A                                 |
| Promedio: 72.4                              |
| Percentil 25: 60                            |
| Percentil 75: 85                            |
|                                             |
| Comparar con: [📘 Semestre anterior ▼]      |
| 📈 [Ver gráfica de evolución]               |
+---------------------------------------------+
```
o

```
+------------------- ESTADÍSTICAS ------------+
| Curso: [ ▼ Seleccionar paralelo ]           |
|---------------------------------------------|
| Nota Promedio: 76.4                         |
| Percentil 25: 62   | Percentil 75: 88       |
| Mejores estudiantes:                        |
| - Juan Pérez (95)                           |
| - Ana López (91)                            |
|---------------------------------------------|
| [ 📉 Comparar con otros semestres ]         |
| [ ⬅️ Volver al menú principal     ]         |
+---------------------------------------------+


```
---

🔧 *Estos mockups están diseñados para ser adaptados y redibujados en herramientas como Figma o en Android Studio, manteniendo un enfoque retro, limpio y funcional.*
