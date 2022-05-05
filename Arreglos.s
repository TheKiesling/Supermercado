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
.align 2
.global main
.type main,%function

/*-- main: inicio y bienvenida --*/
main:
    @@ grabar registro de enlace en la pila
	stmfd sp!, {lr}	/* SP = R13 link register = R14*/

    @@ Bienvenida al programa
    ldr r0,=mensaje_ingreso
    bl puts
    
    mov r10,#8

/*-- solicitud: pide la cantidad de producto y lo actualiza --*/
solicitud:
    @ comparaciones para indicar el producto a solicitar
	cmp r10,#8
    ldreq r4,=leche
    cmp r10,#7
    ldreq r4,=galletas
    cmp r10,#6
    ldreq r4,=mantequilla
    cmp r10,#5
    ldreq r4,=queso
    cmp r10,#4
    ldreq r4,=pan
    cmp r10,#3
    ldreq r4,=jalea
    cmp r10,#2
    ldreq r4,=yogurt
    cmp r10,#1
    ldreq r4,=manzana

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

    @ obtener la cantidad a comprar y la cantidad en stock del producto a comprar
    ldr r4,=cantidad_compra
    ldr r4,[r4]
    ldr r7,=cantidad
    ldr r5,[r7,r9]

    @ comprobar que existe suficiente cantidad
    subs r6,r5,r4
    bmi error_cantidad

    @ actualizar arreglo de consumo y cantidad en stock
    ldr r8,=consumo
	str r4,[r8,r9]
    str r6,[r7,r9]
	add r9,#4

    @ verificar siguiente accion: ciclo o siguiente etiqueta
    subs r10,#1
    bne solicitud
    mov r10,#8
    mov r9,#0

/*-- gasto: genera el subtotal --*/
gasto:
    @ cargar la cantidad a comprar y el precio de dicho producto
    ldr r8,=consumo
    ldr r4,[r8,r9]
    ldr r7,=precio
    ldr r5,[r7,r9]

    @ genera el subtotal
    mul r6,r5,r4

    @ guarda el subtotal en el indice del arreglo correspondiente
    ldr r11,=subtotal
    str r6,[r11,r9]
    add r9,#4

    @ verificar siguiente accion: ciclo o siguiente etiqueta
    subs r10,#1
    bne gasto
    mov r10,#8
    mov r9,#0
    ldr r7,=total
    ldr r7,[r7]

/*-- total_pagar: calcula el total a pagar --*/
total_pagar:
    @ cargar el subtotal de cada producto
    ldr r11,=subtotal
    ldr r4,[r11,r9]

    @ sumar el subtotal
    add r7,r4
    add r9,#4

    @ verificar siguiente accion: ciclo o siguiente etiqueta
    subs r10,#1
    bne total_pagar
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
    ldr r0,=inicio_factura
    bl puts
    ldr r0,=cliente
    ldr r1,=nombre
    bl printf
    ldr r0,=encabezado_factura
    bl puts

/*-- factura: imprime los productos y sus propiedades de compra --*/
factura:
    @ cargar cantidad de producto
    ldr r8,=consumo
    ldr r1,[r8,r9]

    @ cargar cada producto
    cmp r10,#8
    ldreq r4,=leche
    cmp r10,#7
    ldreq r4,=galletas
    cmp r10,#6
    ldreq r4,=mantequilla
    cmp r10,#5
    ldreq r4,=queso
    cmp r10,#4
    ldreq r4,=pan
    cmp r10,#3
    ldreq r4,=jalea
    cmp r10,#2
    ldreq r4,=yogurt
    cmp r10,#1
    ldreq r4,=manzana
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
    ldr r0,=inicio_inventario
    bl puts
    ldr r0,=encabezado_inventario
    bl puts

/*-- inventario: imprime los productos y sus propiedades de almacenamiento --*/
inventario:
    @ cargar cantidad de producto
    ldr r8,=cantidad
    ldr r1,[r8,r9]

    @ cargar cada producto
    cmp r10,#8
    ldreq r4,=leche
    cmp r10,#7
    ldreq r4,=galletas
    cmp r10,#6
    ldreq r4,=mantequilla
    cmp r10,#5
    ldreq r4,=queso
    cmp r10,#4
    ldreq r4,=pan
    cmp r10,#3
    ldreq r4,=jalea
    cmp r10,#2
    ldreq r4,=yogurt
    cmp r10,#1
    ldreq r4,=manzana
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
    ldr r0,=mal_ingreso
    bl puts
    bl getchar
    b salir

/*-- error logico de cantidad --*/
error_cantidad:
    ldr r0,=mal_cantidad
    bl puts
    bl getchar
    b salir

/*-- Salida del programa --*/
salir:
    @@salida segura
    mov r0, #0
    mov r3, #0
    ldmfd sp!, {lr}
    bx lr

/* --------------------------------------- DATA --------------------------------------- */
.data
.align 2

/*-- Variables --*/
leche: .asciz "Leche \t\t\t Q.18.00"
galletas: .asciz "P. Galletas \t\t Q.25.00"
mantequilla: .asciz "Mantequilla \t\t Q.10.00"
queso: .asciz "Queso \t\t\t Q.35.00"
pan: .asciz "Uni. Pan \t\t Q.4.00"
jalea: .asciz "Jalea \t\t\t Q.26.00"
yogurt: .asciz "Uni. Yogurt \t\t Q.8.00"
manzana: .asciz "Lb. Manzana \t\t Q.19.00"
cantidad: .word 20,32,15,15,20,18,35,35
precio: .word 18,25,10,35,4,26,8,19
consumo: .word 0,0,0,0,0,0,0,0
cantidad_compra: .word 0
nombre: .asciz "                    "
total: .word 0
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
    .asciz "Ingreso incorrecto, solo se pueden ingresar numeros"
mal_cantidad: 
    .asciz "No hay suficiente cantidad de este producto"
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
