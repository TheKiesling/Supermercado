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
main:
    @@ grabar registro de enlace en la pila
	stmfd sp!, {lr}	/* SP = R13 link register = R14*/

    @@ Bienvenida al programa
    ldr r0,=mensaje_ingreso
    bl puts
    
    mov r10,#8

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

    @@imprimir mensaje de solicitud
    mov r1,r4
    ldr r0,=ingreso
    bl printf

    @ solicitud de cantidad a comprar
    ldr r0,=formato_d
    ldr r1,=cantidad_compra
	bl scanf

    cmp r0,#0
    beq error_ingreso

    ldr r4,=cantidad_compra
    ldr r4,[r4]
    ldr r7,=cantidad
    ldr r5,[r7,r9]

    subs r6,r5,r4
    bmi error_cantidad

    ldr r8,=consumo
	str r4,[r8,r9]
    str r6,[r7,r9]
	add r9,#4

    subs r10,#1
    bne solicitud
    beq salir

/*-- Salto para error de num --*/
error_ingreso:
    ldr r0,=mal_ingreso
    bl puts
    bl getchar
    b salir

error_cantidad:
    ldr r0,=mal_cantidad
    bl puts
    bl getchar
    b salir

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
leche: .asciz "Leche"
galletas: .asciz "P. Galletas"
mantequilla: .asciz "Mantequilla"
queso: .asciz "Queso"
pan: .asciz "Uni. Pan"
jalea: .asciz "Jalea"
yogurt: .asciz "Uni. Yogurt"
manzana: .asciz "Lb. Manzana"
cantidad: .word 20,32,15,15,20,18,35,35
precio: .word 18,25,10,35,4,26,8,19
consumo: .word 0,0,0,0,0,0,0,0
cantidad_compra: .word 0
nombre: .asciz "                    "
total: .word 0

/*-- Mensajes --*/
formato_string:
	.asciz "%s"
formato_d:
    .asciz "%d"
mensaje_ingreso: 
    .asciz "Bienvenido a su programa Supermercado"
ingreso:
    .asciz "Ingrese la cantidad de compra de %s:\n"
mal_ingreso: 
    .asciz "Ingreso incorrecto, solo se pueden ingresar numeros"
mal_cantidad: 
    .asciz "No hay suficiente cantidad de este producto"
