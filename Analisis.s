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
* Analisis.s
* Subrutinas que colaboran con las operaciones en una tienda de productos
* Las subrutinas son las siguientes:
* - Actualizacion: modifica los arreglos de productos
* - Mensaje: decide que mensaje mostrar
* - Gasto: genera el subtotal
* - Total_pagar: calcula el total a pagar
 -------------------------------------------------------------------------------------- */

@Subrutina que modifica los arreglos de productos
@Parametros de entrada:
@r4: cantidad a comprar de producto
@r7: cantidad existente del producto en tienda
.global _actualizacion
_actualizacion:
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

    mov pc,lr

@Subrutina que decide que mensaje mostrar
@Parametros de entrada:
@r10: numero de ciclo
@Parametros de salida
@r4: mensaje
.global _mensaje
_mensaje:
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
    mov pc, lr

@Subrutina que genera el subtotal
@Parametros de entrada:
@r8: cantidad de consumo de cada producto
@r7: precio de cada producto
.global _gasto
_gasto:
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
    bne _gasto
    mov pc,lr

@Subrutina que genera el subtotal
@Parametros de entrada:
@r11: subtotal de cada producto
.global _total_pagar
_total_pagar:
    @ cargar el subtotal de cada producto
    ldr r11,=subtotal
    ldr r4,[r11,r9]

    @ sumar el subtotal
    add r7,r4
    add r9,#4

    @ verificar siguiente accion: ciclo o siguiente etiqueta
    subs r10,#1
    bne _total_pagar
    mov pc,lr
