/* --------------------------------------------------------------------------------------
* #      #    #######    ########   #######   #          #######   ##      #    #########
* #     #        #       #          #         #             #      # #     #    #
* #    #         #       #          #         #             #      #  #    #    #
* ####           #       #####      #######   #             #      #   #   #    #    ####
* #    #         #       #                #   #             #      #    #  #    #       #
* #     #        #       #                #   #             #      #     # #    #       #
* #      #    ########   ########   #######   ########   #######   #      ##    #########
* 
* UNIVERSIDAD DEL VALLE DE GUATEMALA 
* Organización de computadoras y Assembler
* Ciclo 1 - 2022
* -------------------------------
* Emily Elvia Perez Alarcon 21385
* Jose Pablo Kiesling Lange 21581
* -------------------------------
* Arreglos.s
* Sistema que permite generar recibos de compra a los clientes, teniendo el 
* registro de productos y existencias.   
 -------------------------------------------------------------------------------------- */

/* --------------------------------------- TEXT --------------------------------------- */
.text
.global main
/*-- main: inicio y bienvenida --*/
main:
    @@ Bienvenida al programa
    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#39 @ tamano de cadena
    ldr r1,=mensaje_ingreso @ mensaje a imprimir
    swi 0
    
    mov r10,#8

/*-- solicitud: pide la cantidad de producto y lo actualiza --*/
solicitud:
    @ indicar que mensaje se mostrara
    bl _mensaje

    @ imprimir mensaje de solicitud
    mov r1,r4
    ldr r0,=ingreso
    bl printf

    @ solicitud de cantidad a comprar
    ldr r0,=formato_d
    ldr r1,=cantidad_compra
    bl scanf

    @ ingreso correcto
    cmp r0,#0
    beq error_ingreso

    @ actualizar arreglos
    bl _actualizacion

    @ verificar siguiente accion: ciclo o siguiente etiqueta
    subs r10,#1
    bne solicitud

    @ resetear registros
    mov r10,#8
    mov r9,#0

    @ generar subtotal de cada producto
    bl _gasto

    @ setear registros
    mov r10,#8
    mov r9,#0
    ldr r7,=total
    ldr r7,[r7]

    @ calcular total a pagar
    bl _total_pagar

    @ guardar total en etiqueta
    ldr r6,=total
    str r7,[r6]
    mov r10,#8
    mov r9,#0

/*-- impresion_factura: imprime la factura --*/
impresion_factura:
    @ solicitar nombre del cliente
    ldr r0,=ingreso_nombre 
    bl puts
    ldr r0,=formato_string
    ldr r1,=nombre
    bl scanf

    @ mostrar parte inicial de la factura
    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#19 @ tamano de cadena
    ldr r1,=inicio_factura @ mensaje a imprimir
    swi 0
    
    ldr r0,=cliente
    ldr r1,=nombre
    bl printf

    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#50 @ tamano de cadena
    ldr r1,=encabezado_factura @ mensaje a imprimir
    swi 0

/*-- factura: imprime los productos y sus propiedades de compra --*/
factura:
    @ cargar cantidad de producto
    ldr r8,=consumo
    ldr r1,[r8,r9]

    bl _mensaje
    mov r2,r4

    @ cargar el subtotal de cada producto
    ldr r11,=subtotal
    ldr r3,[r11,r9]

    @ imprime todos los productos
	ldr r0,=productos_factura
	bl printf
	add r9,#4	

    @ verificar siguiente accion: ciclo o siguiente etiqueta
	subs r10,#1	
	bne factura

    @ imprimir total de la compra
    ldr r0,=costo_total
    ldr r1,=total
    ldr r1,[r1]
    bl printf

    mov r10,#8
    mov r9,#0

/*-- impresion_inventario: imprime el inventario --*/
impresion_inventario:
    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#22 @ tamano de cadena
    ldr r1,=inicio_inventario @ mensaje a imprimir
    swi 0

    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#39 @ tamano de cadena
    ldr r1,=encabezado_inventario @ mensaje a imprimir
    swi 0

/*-- inventario: imprime los productos y sus propiedades de almacenamiento --*/
inventario:
    @ cargar cantidad de producto
    ldr r8,=cantidad
    ldr r1,[r8,r9]

    bl _mensaje
    mov r2,r4

    @ imprime todos los productos
    ldr r0,=productos_inventario
	bl printf
    add r9,#4	

    @ verificar siguiente accion: ciclo o siguiente etiqueta
	subs r10,#1	
	bne inventario
    b salir

/*-- error de ingreso --*/
error_ingreso:
    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#52 @ tamano de cadena
    ldr r1,=mal_ingreso @ mensaje a imprimir
    swi 0

    b salir

.global error_cantidad
/*-- error logico de cantidad --*/
error_cantidad:
    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#44 @ tamano de cadena
    ldr r1,=mal_cantidad @ mensaje a imprimir
    swi 0

    b salir

/*-- Salida del programa --*/
salir:
    @@salida segura
    mov r7,#1
    swi 0

/* --------------------------------------- DATA --------------------------------------- */
.data
.align 2

/*-- Variables --*/
.global leche
leche: .asciz "Leche \t\t\t Q.18.00"
.global galletas
galletas: .asciz "P. Galletas \t\t Q.25.00"
.global mantequilla
mantequilla: .asciz "Mantequilla \t\t Q.10.00"
.global queso
queso: .asciz "Queso \t\t\t Q.35.00"
.global pan
pan: .asciz "Uni. Pan \t\t Q.4.00"
.global jalea
jalea: .asciz "Jalea \t\t\t Q.26.00"
.global yogurt
yogurt: .asciz "Uni. Yogurt \t\t Q.8.00"
.global manzana
manzana: .asciz "Lb. Manzana \t\t Q.19.00"
.global cantidad
cantidad: .word 20,32,15,15,20,18,35,35
.global precio
precio: .word 18,25,10,35,4,26,8,19
.global consumo
consumo: .word 0,0,0,0,0,0,0,0
.global cantidad_compra
cantidad_compra: .word 0
.global nombre
nombre: .asciz "                    "
.global total
total: .word 0
.global subtotal
subtotal: .word 0,0,0,0,0,0,0,0

/*-- Mensajes --*/
formato_string:
	.asciz "%s"
formato_d:
    .asciz " %d"
mensaje_ingreso: 
    .asciz "Bienvenido a su programa Supermercado"
ingreso:
    .asciz "\nIngrese la cantidad de compra de %s:\n"
mal_ingreso: 
    .asciz "Ingreso incorrecto, solo se pueden ingresar numeros\n"
mal_cantidad: 
    .asciz "No hay suficiente cantidad de este producto\n"
ingreso_nombre:
    .asciz "\nIngrese su nombre para generar la factura:"
inicio_factura:
    .asciz "\n --- FACTURA --- \n"
cliente:
    .asciz "\nCliente: %s \n"
encabezado_factura: 
    .asciz "\nCant. \t\t Descripcion \t\t Prec.Unit. \t\t Subtotal Q\n"
productos_factura:
    .asciz "%d \t\t %s \t\t %d\n"
costo_total:
    .asciz "\n\t\t\t\t\t TOTAL:\t\t\t %d\n"
inicio_inventario:
    .asciz "\n --- INVENTARIO --- \n"
encabezado_inventario:
    .asciz "\n Cant. \t\t Descripcion \t\t Prec.Unit.Q.\n"
productos_inventario:
    .asciz "%d \t\t %s \n"
