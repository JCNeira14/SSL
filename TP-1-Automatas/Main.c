#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <ctype.h>

/*
Matriz para decimales:
Estado inicial: q0
Estados finales: qf
Estado de error léxico: qe
Estado   | 0-9 | -  | $  | Otros
---------------------------------
q0       | q1  | q2 | qe | qe
q1       | q1  | qe | qf | qe
q2       | q3  | qe | qe | qe
q3       | q3  | qe | qf | qe
qf (Final)| -  | -  | -  | -
qe (Error)| -  | -  | -  | -

Matriz para octales:
Estado inicial: q0
Estados finales: qf
Estado de error léxico: qe
Estado   | 0-7 | 8-9 | -  | $  | Otros
-------------------------------------
q0       | q1  | qe  | q2 | qe | qe
q1       | q1  | qe  | qf | qe | qe
q2       | q3  | qe  | qe | qe | qe
q3       | q3  | qe  | qf | qe | qe
qf (Final)| -  | -   | -  | -  | -
qe (Error)| -  | -   | -  | -  | -

Matriz para hexadecimales:
Estado inicial: q0
Estados finales: qf
Estado de error léxico: qe
Estado   | 0-9 | A-F | a-f | -  | $  | Otros
-----------------------------------------
q0       | q1  | q1  | q1  | q2 | qe | qe
q1       | q1  | q1  | q1  | qf | qe | qe
q2       | q3  | q3  | q3  | qe | qe | qe
q3       | q3  | q3  | q3  | qf | qe | qe
qf (Final)| -  | -   | -   | -  | -  | -
qe (Error)| -  | -   | -   | -  | -  | -
*/

enum State
{ // Definición de estados

    q0,   // Estado inicial
    qDec, // Estado para números decimales
    qOct, // Estado para números octales
    qHex, // Estado para números hexadecimales
    qErr  // Estado de Error léxico
};

// Función de transición para el AFD
enum State transition(enum State current_state, char input, char futureInput)
{

    switch (current_state)
    {

    case q0:

        if (input == '0')
        {

            if (futureInput == 'X')
            {

                return qHex;
            }

            else
            {
                return qOct; // Número octal
            }
        }

        if (input > '0' && input <= '9')
        {

            return qDec; // Número decimal
        }

        else if (input == '-')
        {

            return qDec; // Número decimal negativo
        }

        else if (input == '$')
        {

            return qErr; // Error léxico
        }

        break;

    case qDec:

        if (input >= '0' && input <= '9')
        {

            return qDec; // Continúa número decimal
        }

        else if (input == '$')
        {

            return q0; // Fin de número decimal
        }

        else
        {

            return qErr; // Error léxico
        }

    case qHex:

        if ((input >= '0' && input <= '9') || (input >= 'A' && input <= 'F') ||
            (input == 'X'))
        {

            return qHex; // Continúa número hexadecimal
        }

        else if (input == '$')
        {

            return q0; // Fin de número hexadecimal
        }

        else
        {

            return qErr; // Error léxico
        }

    case qOct:

        if (input >= '0' && input <= '7')
        {

            return qOct; // Continúa número octal
        }

        else if (input == '$')
        {

            return q0; // Fin de número octal
        }

        else
        {

            return qErr; // Error léxico
        }

    case qErr:

        return qErr; // Error léxico
    }

    return qErr; // Error léxico
}

void testDecimal()
{
    printf("\nTest Punto 1\n");
    char input[] = "123$";
    enum State current_state = q0;

    for (int i = 0; i < strlen(input); i++)
    {
        char c = input[i];
        char c2 = input[i + 1];
        current_state = transition(current_state, c, c2);
    }

    if (current_state != qErr)
    {
        printf("Test Decimal: Correcto\n");
    }

    else
    {
        printf("Test Decimal: Incorrecto\n");
    }
}

void testOctal()
{

    char input[] = "0123$";
    enum State current_state = q0;

    for (int i = 0; i < strlen(input); i++)
    {
        char c = input[i];
        char c2 = input[i];
        current_state = transition(current_state, c, c2);
    }

    if (current_state != qErr)
    {
        printf("Test Octal: Correcto\n");
    }

    else
    {
        printf("Test Octal: Incorrecto\n");
    }
}

void testHexadecimal()
{

    char input[] = "0XABC$";
    enum State current_state = q0;

    for (int i = 0; i < strlen(input); i++)
    {
        char c = input[i];
        char c2 = input[i + 1];
        current_state = transition(current_state, c, c2);
    }

    if (current_state != qErr)
    {
        printf("Test Hexadecimal: Correcto\n");
    }

    else
    {
        printf("Test Hexadecimal: Incorrecto\n");
    }
}

void testMixto()
{

    char input[] = "123$0123$0XABC$-45";
    enum State current_state = q0;

    for (int i = 0; i < strlen(input); i++)
    {
        char c = input[i];
        char c2 = input[i + 1];
        current_state = transition(current_state, c, c2);
    }

    if (current_state != qErr)
    {
        printf("Test Datos Mixtos: Correcto\n");
    }

    else
    {
        printf("Test Datos Mixtos: Incorrecto\n");
    }
}

void testError()
{

    char input[] = "12#$";
    enum State current_state = q0;

    for (int i = 0; i < strlen(input); i++)
    {
        char c = input[i];
        char c2 = input[i];
        current_state = transition(current_state, c, c2);
    }

    if (current_state == qErr)
    {
        printf("Test Error Léxico: Correcto\n");
    }

    else
    {
        printf("Test Error Léxico: Incorrecto\n");
    }
}

void convertirAMayusculas(char *caracter)
{

    // Convierte el caracter enviado (alfabético) a mayúscula
    *caracter = toupper(*caracter);
}

int modoAutomata(char *input)
{

    int decimal_count = 0;
    int octal_count = 0;
    int hexadecimal_count = 0;
    bool error = false;

    // Eliminar el carácter de salto de línea si existe
    size_t len = strlen(input);
    if (len > 0 && input[len - 1] == '\n')
    {
        input[len - 1] = '\0';
    }

    // Itera sobre la cadena ingresada una cantidad de veces = a su longitud
    for (int i = 0; i < len; i++)
    {
        // Verifica si el carácter leído es una letra
        if (isalpha(input[i]))
        {
            convertirAMayusculas(&input[i]); // Lo pasa a mayúsculas
        }
    }

    // Iterar sobre cada carácter de la cadena
    enum State current_state = q0;

    for (int i = 0; i < strlen(input); i++)
    {
        char c = input[i];
        char c2 = input[i + 1];

        // Transición de estado
        current_state = transition(current_state, c, c2);

        // Contar números en los estados finales
        if (current_state == qDec)
        {
            decimal_count++;
        }

        else if (current_state == qOct)
        {
            octal_count++;
        }

        else if (current_state == qHex)
        {
            hexadecimal_count++;
        }

        else if (current_state == qErr)
        {
            error = true;
            break;
        }
    }

    if (error)
    {
        printf("Error léxico\n");
    }

    else
    {
        printf("Cantidad de números decimales: %d\n", decimal_count);
        printf("Cantidad de números octales: %d\n", octal_count);
        printf("Cantidad de números hexadecimales: %d\n", hexadecimal_count);
    }

    printf("\n");

    return 0;
}

// Punto 2
long long int conversorCaracteresNumericos(const char *cadena)
{
    long long int numero = atoll(cadena); // Utilizando atoll para convertir a long long int
    return numero;
}

bool ejecutarTestConversor(const char *cadena, int resultadoEsperado)
{
    long long int resultado = conversorCaracteresNumericos(cadena);
    if (resultado == resultadoEsperado)
    {
        printf("Test \"%s\": Correcto\n", cadena);
        return true;
    }
    else
    {
        printf("Test \"%s\": Incorrecto (Esperado: %d, Obtenido: %d)\n", cadena, resultadoEsperado, resultado);
        return false;
    }
}

void realizarTestsConversor()
{
    printf("\nTests Punto 2\n");

    bool todosLosTestsPasaron = true;

    todosLosTestsPasaron &= ejecutarTestConversor("123", 123);    // Test con número positivo
    todosLosTestsPasaron &= ejecutarTestConversor("-456", -456);  // Test con número negativo
    todosLosTestsPasaron &= ejecutarTestConversor("0", 0);        // Test con cero
    todosLosTestsPasaron &= ejecutarTestConversor("123abc", 123); // Test con caracteres no numéricos al final
    todosLosTestsPasaron &= ejecutarTestConversor("abc123", 0);   // Test con caracteres no numéricos al principio
    todosLosTestsPasaron &= ejecutarTestConversor("", 0);         // Test con cadena vacía

    if (todosLosTestsPasaron)
    {
        printf("Todos los tests del punto 2 pasaron.\n");
    }
    else
    {
        printf("Algunos tests del punto 2 fallaron.\n");
    }
}

// Punto 3
typedef struct
{
    int valor;
    char operador;
    bool esOperador;
} ElementoExpresion;

int prioridadOperador(char operador)
{
    if (operador == '+' || operador == '-')
    {
        return 1;
    }
    else if (operador == '*' || operador == '/')
    {
        return 2;
    }
    return 0; // Si no es un operador válido
}

void push(ElementoExpresion *pila, int *top, ElementoExpresion elemento)
{
    (*top)++;
    pila[*top] = elemento;
}

ElementoExpresion pop(ElementoExpresion *pila, int *top)
{
    ElementoExpresion elemento = pila[*top];
    (*top)--;
    return elemento;
}

int evaluarExpresion(const char *expresion)
{
    ElementoExpresion pilaOperadores[100];
    ElementoExpresion pilaOperandos[100];
    int topOperadores = -1;
    int topOperandos = -1;
    int i = 0;

    while (expresion[i] != '\0')
    {
        if (isdigit(expresion[i]) || (expresion[i] == '-' && (i == 0 || !isdigit(expresion[i - 1]))))
        {
            int numero = 0;
            bool negativo = false;
            if (expresion[i] == '-')
            {
                negativo = true;
                i++;
            }
            while (isdigit(expresion[i]))
            {
                numero = numero * 10 + (expresion[i] - '0');
                i++;
            }
            if (negativo)
            {
                numero = -numero;
            }
            ElementoExpresion elemento = {numero, '\0', false};
            push(pilaOperandos, &topOperandos, elemento);
        }
        else if (expresion[i] == '+' || expresion[i] == '-' || expresion[i] == '*' || expresion[i] == '/')
        {
            while (topOperadores >= 0 && prioridadOperador(expresion[i]) <= prioridadOperador(pilaOperadores[topOperadores].operador))
            {
                ElementoExpresion operador = pop(pilaOperadores, &topOperadores);
                ElementoExpresion operando2 = pop(pilaOperandos, &topOperandos);
                ElementoExpresion operando1 = pop(pilaOperandos, &topOperandos);

                int resultado;
                if (operador.operador == '+')
                {
                    resultado = operando1.valor + operando2.valor;
                }
                else if (operador.operador == '-')
                {
                    resultado = operando1.valor - operando2.valor;
                }
                else if (operador.operador == '*')
                {
                    resultado = operando1.valor * operando2.valor;
                }
                else if (operador.operador == '/')
                {
                    resultado = operando1.valor / operando2.valor;
                }

                ElementoExpresion resultadoElemento = {resultado, '\0', false};
                push(pilaOperandos, &topOperandos, resultadoElemento);
            }

            ElementoExpresion elemento = {0, expresion[i], true};
            push(pilaOperadores, &topOperadores, elemento);
            i++;
        }
        else
        {
            // Ignorar espacios y otros caracteres no válidos
            i++;
        }
    }

    // Resolver cualquier operador restante en la pila
    while (topOperadores >= 0)
    {
        ElementoExpresion operador = pop(pilaOperadores, &topOperadores);
        ElementoExpresion operando2 = pop(pilaOperandos, &topOperandos);
        ElementoExpresion operando1 = pop(pilaOperandos, &topOperandos);

        // Verificar si el divisor es cero
        if (operador.operador == '/' && operando2.valor == 0)
        {
            printf("Error: División por cero.\n");
            exit(EXIT_FAILURE);
        }

        int resultado;
        if (operador.operador == '+')
        {
            resultado = operando1.valor + operando2.valor;
        }
        else if (operador.operador == '-')
        {
            resultado = operando1.valor - operando2.valor;
        }
        else if (operador.operador == '*')
        {
            resultado = operando1.valor * operando2.valor;
        }
        else if (operador.operador == '/')
        {
            resultado = operando1.valor / operando2.valor;
        }

        ElementoExpresion resultadoElemento = {resultado, '\0', false};
        push(pilaOperandos, &topOperandos, resultadoElemento);
    }

    return pilaOperandos[topOperandos].valor;
}

bool ejecutarTestAritmetico(const char *expresion, int resultadoEsperado)
{
    int resultado = evaluarExpresion(expresion);
    if (resultado == resultadoEsperado)
    {
        printf("Test \"%s\": Correcto\n", expresion);
        return true;
    }
    else
    {
        printf("Test \"%s\": Incorrecto\n", expresion);
        return false;
    }
}

void realizarTestsAritmeticos()
{
    printf("\nTests Punto 3\n");

    bool todosLosTestsPasaron = true;

    todosLosTestsPasaron &= ejecutarTestAritmetico("3+4*8/2+3-5", 17);
    todosLosTestsPasaron &= ejecutarTestAritmetico("-10-4+14", 0);
    todosLosTestsPasaron &= ejecutarTestAritmetico("10*2-6/2", 17);
    todosLosTestsPasaron &= ejecutarTestAritmetico("2+3*4-8/2", 10);

    if (todosLosTestsPasaron)
    {
        printf("Todos los tests pasaron.\n\n");
    }
    else
    {
        printf("Algunos tests fallaron.\n\n");
    }
}

int main()
{
    int modoDeOperacion, condicion = 1;

    char cadenaDeCaracteres[100];
    char expresion[100];

    printf("\nBienvenido al Programa de Práctica 2 de SSL (Sintaxis y Semántica de los Lenguajes).\n");
    printf("Este programa le permite realizar diversas operaciones y pruebas relacionadas con los autómatas.\n");

    while (condicion)
    {
        printf("\nPor favor, seleccione una opción ingresando el número correspondiente:\n");
        printf("1. Ejecutar punto 1: Verificar con el autómata la cadena ingresada.\n");
        printf("2. Ejecutar punto 2: Convertir caracteres numéricos en un número entero.\n");
        printf("3. Ejecutar punto 3: Resolver operación ingresada.\n");
        printf("4. Ejecutar todos los tests\n");
        printf("5. Terminar programa\n");
        scanf("%d", &modoDeOperacion);

        switch (modoDeOperacion)
        {

        case 1:
            printf("\nIngrese la cadena de entrada: ");
            scanf("%s", cadenaDeCaracteres);

            modoAutomata(cadenaDeCaracteres);
            break;

        case 2:
            printf("\nIngrese caracteres numéricos: ");
            scanf("%s", cadenaDeCaracteres);

            int numeroConvertido = conversorCaracteresNumericos(cadenaDeCaracteres);
            printf("\tNumero decimal: %d\n\n", numeroConvertido);
            break;

        case 3:

            printf("Ingrese la expresion aritmetica: ");
            scanf("%s", expresion);

            int resultado = evaluarExpresion(expresion);

            printf("El resultado de la expresion es: %d\n", resultado);
            break;

        case 4:
            // Tests punto 1
            testDecimal();
            testOctal();
            testHexadecimal();
            testMixto();
            testError();

            // Tets punto 2
            realizarTestsConversor();

            // Test punto 3
            realizarTestsAritmeticos();
            break;

        case 5:
            return 0;

        default:
            printf("Error. Por favor elija un numero.\n");
            break;
        }
    }
}
