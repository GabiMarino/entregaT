# Entrega Gabriel Marino - 331938


#!/bin/bash

while true; do
    read -p "Ingrese usuario: " usuario
    # la s hace que no se muestre lo que se ingresa
    read -sp "Ingrese contraseña: " contrasena
    echo ""
    combinacion="${usuario}=${contrasena}"
    if grep -qx "$combinacion" documento.txt; then
        # q es para que grep opere en modo silencioso.
        # x obliga a grep a que coincida la linea completa
        echo ""
        echo "Usuario y contraseña confirmados."
        break
    else
        echo ""
        echo "Usuario o contraseña incorrectos."
    fi
done

letraInicial=""
letraFinal=""
letraContenida=""
vocal=""

while true; do
    echo ""
    echo "-------------------------------"
    echo "Opcion 1-Listar los usarios registrados"
    echo "Opcion 2- Dar de alta a un usuario"
    echo "Opcion 3- Configurar letra de inicio"
    echo "Opcion 4- Configurar letra de fin"
    echo "Opcion 5- Configurar letra contenida"
    echo "Opcion 6- Consultar diccionario"
    echo "Opcion 7- Ingresar vocal"
    echo "Opcion 8- Listar palabras del diccionario con esa vocal"
    echo "Opcion 9- Algoritmo 1"
    echo "Opcion 10- Algoritmo 2"
    echo "Opcion 0- salir"
    echo "---------------------------"
    read -p "Ingrese una opcion: " opcion

    case $opcion in
    1)
        echo "Lista de usuarios"
        cut -d'=' -f1 documento.txt

        ;;

    2)
        echo "------------------------"
        echo "Dar de alta a un usuario"
        echo "------------------------"
        while true; do
            read -p "Ingrese nombre de usuario: " usu
            read -p "Ingrese la contraseña del usuario: " pass
            registro="${usu}=${pass}"
            if grep -q "$usu" documento.txt; then
                echo "El usuario ya existe, ingrese nuevamente"
            else
                echo "Usuario registrado correctamente."
                echo "$registro" >>documento.txt
                break
            fi
        done
        ;;

    3)
        echo "Configurar letra de inicio"
        #^ representa el comienzo de la linea
        #=~ es un operador de coincidencia de expresiones regulares. O sea se usa
        # para verificar que el contenido de la variable coincida con el patron de
        # la expresion regular ( ^[a-zA-Z]$ ). $ al fina de la expresion junto a ^
        # al inicio hacen que solo se pueda ingresar una letra.
        # $ representa el final de la linea.
        while true; do
            read -p "Ingrese una letra inicial: " letraInicial
            if [[ $letraInicial =~ ^[a-zA-Z]$ ]]; then
                echo "Ha ingresado la letra: $letraInicial"
                break
            else
                echo "Entrada inválida. Debe ingresar una letra."
            fi
        done
        ;;

    4)
        echo "Configurar letra final"
        while true; do
            read -p "Ingrese una letra final: " letraFinal
            if [[ $letraFinal =~ ^[a-zA-Z]$ ]]; then
                echo "Ha ingresado la letra: $letraFinal"
                break
            else
                echo "Entrada inválida. Debe ingresar una letra."
            fi
        done
        ;;

    5)
        echo "Configurar letra contenida"
        while true; do
            read -p "Ingrese una letra contenida: " letraContenida
            if [[ $letraContenida =~ ^[a-zA-Z]$ ]]; then
                echo "Ha ingresado la letra: $letraContenida"
                break
            else
                echo "Entrada inválida. Debe ingresar una letra."
            fi
        done
        ;;

    6)
        #Verificamos que esten las tres letras ingresadas.
        #-z lo que hace es devolver true si la variable esta vacia.
        # el operador or devuelve true si al menos una variable es true(esta vacia)
        # si alguna variable esta vacia la expresion pasa a ser true y ejecuta el if.
        if [ -z "$letraInicial" ] || [ -z "$letraContenida" ] || [ -z "$letraFinal" ]; then
            echo "Debe configurar la letra inicial, la letra contenida y la letra final antes de consultar el diccionario."
        else
            # ^representa el inicio de la linea, $ representa el final de la linea.
            # * hace que no importe cuanta cantidad de caracteres esten entre las letras
            resultado=$(grep -a -E "^$letraInicial.*$letraContenida.*$letraFinal$" diccionario.txt)
            fecha=$(date +"%d-%m-%Y")
            #El comando wc se usa para contar, pueden ser palabras, letras, bytes o lineas de un archivo. Al poner -l hacemos que solo cuente lineas.
            # | basicamente le pasa el resultado de wc -l a awk
            # awk {print$1} imprime el primer campo de wc (la salida de wc seria algo
            # como '200 diccionario.txt") entonces al poner print$1 solo se muestra 200.
            cantidad_total=$(wc -l diccionario.txt | awk '{print $1}')

            #Verificamos si resultado esta vacio. Si esta vacio le asignamos 0 (por defecto se asigna 1)
            if [ -z "$resultado" ]; then
                cantidad_resultado=0
            else
                #Lo que estamos haciendo es contar las lineas(-l) de $resultado.
                cantidad_resultado=$(echo "$resultado" | wc -l)
            fi
            #Regla de 3 para calcular el porcentaje de palabras que cumplen lo pedido.
            #Scale lo que hace es indicar cuantos decimales se quieren.
            porcentaje=$(echo "scale=3; ($cantidad_resultado * 100) / $cantidad_total" | bc)

            echo "Resultados:"

            if [ "$cantidad_resultado" -eq 0 ]; then
                echo "No se encontraron palabras que coincidan con la configuracion"
            else
                echo "$resultado"

                echo "Fecha de ejecucion del informe: $fecha" >>informe.txt
                echo "Cantidad de palabras totales: $cantidad_total" >>informe.txt
                echo "Cantidad de palabras que cumplen lo pedido: $cantidad_resultado" >>informe.txt
                echo "Porcentaje de palabras que cumplen lo pedido: $porcentaje" >>informe.txt
                echo "Nombre de usuario registrado a la hora de guardar el script: $usuario" >>informe.txt
                echo "Palabras que cumplen lo solicitado: " >>informe.txt
                echo "" >>informe.txt
                echo "$resultado" >>informe.txt
                echo "" >>informe.txt
            fi
        fi

        ;;

    7)
        while true; do
            read -p "Ingrese una vocal: " vocal
            if [[ $vocal =~ ^[aeiouAEIOU]$ ]]; then
                echo "Ha ingresado la vocal: $vocal"
                break
            else
                echo "Entrada inválida. Debe ingresar una vocal."
            fi
        done
        ;;

    8)
        if [ -z "$vocal" ]; then
            echo "Error. Debe ingresar una vocal."
        else
            echo "Palabras que contienen la vocal $vocal:"
            # El -i se usa para no distinguir entre mayusculas y minusculas.
            # .* hace que no importe si hay cero o mas letras antes o despues de la vocal.
            grep -i -a ".*$vocal.*" diccionario.txt
        fi
        ;;

    9)
        echo "Algoritmo 1"
        echo "Cuantos datos desea ingresar?"
        read cantidad

        function promedio() {
            local suma=0
            local max=-99999999999
            local min=99999999999
            #El for se utiliza para generar un loop y preguntar las veces necesarias por un dato
            for ((i = 1; i <= cantidad; i++)); do
                read -p "Ingrese el dato #$i: " dato
                #La variable suma se genera con el propósito de luego calcular el promedio
                suma=$((suma + dato))

                if [ "$dato" -le "$min" ]; then
                    min=$dato
                fi

                if [ "$dato" -ge "$max" ]; then
                    max=$dato
                fi
            done

            local promedio=$(echo "scale=2; $suma / $cantidad" | bc -l)
            echo "El promedio de los datos ingresados es: $promedio"
            echo "El menor numero es: $min"
            echo "El mayor numero es: $max"
        }

        promedio

        ;;

    10)
        echo "Algoritmo 2"
        function capicua() {

            read -p "Ingrese una palabra: " palabra
            longitud=${#palabra}
            mitad=$((longitud / 2))

            if [ "$longitud" -eq 3 ]; then
                if [ "${palabra:o:1}" != "${palabra:2:1}" ]; then
                    echo "La palabra $palabra no es capicua"
                    return
                    echo "La palabra $palabra es capicua"
                fi
            fi

            for ((i = 1; i <= mitad; i++)); do
                #Se compara para verificar si el primer carácter de la palabra en la posición 0 en este caso es diferente al último carácter (posición “-1”)
                if [ "${palabra:i:1}" != "${palabra: -i-1:1}" ]; then
                    echo "La palabra $palabra no es capicua."
                    return
                fi
            done
            echo "La palabra $palabra es capicua"
        }
        capicua

        ;;

    0)
        echo "Saliendo del programa"
        break
        ;;
    *)
        echo "Opcion invalida"
        ;;
    esac
done
