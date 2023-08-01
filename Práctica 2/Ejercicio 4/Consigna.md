# Ejercicio 4
## Consigna
Suponga que trabaja en una oficina donde está montada una LAN (red local). 

La misma fue construida sobre una topología de red que conecta **5** máquinas entre sí y todas las máquinas se conectan con un servidor central.

Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas  por cada usuario en cada terminal y por cuánto tiempo estuvo abierta. 

**Cada archivo detalle contiene los siguientes campos:**
* Codigo de Usuario
* Fecha
* Tiempo de Sesion

Debe realizar un procedimiento que reciba los archivos detalle y genere **un archivo maestro con los siguientes datos:**
* Codigo de Usuario
* Fecha
* Tiempo total de sesiones abiertas

### Notas:
* Cada archivo detalle está ordenado por CodigoDeUsuario y Fecha.
* Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes máquinas.
* El archivo maestro debe crearse en la siguiente ubicación física: /var/log.