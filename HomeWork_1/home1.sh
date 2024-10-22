# Это шебанг - подсказывает ОС, где лежит интерпретатор, который надо использовать.
# Shell-скрипты интерпретируются с помощью интерпретатора bash

#!/bin/bash

# Если пользователь ввёл больше, чем два параметра - выдаём ошибку
if [ $# -gt 2 ]
then
    echo "The input arguments are incorrect"
    exit
fi

# Если пользователь ввёл два парамаетра при запуске
if [ $# -eq 2 ]
then
    path=$1
    parameter=$2
fi

# Если пользователь ввёл один параметр, то просим ввести второй
if [ $# -eq 1 ]
then
    path=$1
    echo "Please, write the parameter"
    read parameter
fi

if [ $# -eq 0 ]
then
    echo "Please, write the path"
    read path
    echo "Please, write the parameter"
    read parameter
fi

# Если пользователь ввёл строку с пробелами, то не удастся выполнить корректную проверку, поэтому удалим пробелы
path="$(tr -d ' ' <<< "$path")"

# Проверка на то, что введённый параметр - существующая на компьютере папка
if ! [ -d $path ]
then
    echo "Path is not correct"
    exit
fi

# Проверка на корректность ввода второго параметра
if [[ $((parameter)) != $parameter ]]
then
    echo "Parameter is not a number"
    exit
fi

# Если в конце введённого пути есть /, то это помешает корректно посчитать заполненность папки, нужно просто удалить его
# Первый этап - проверка на то, что в конце переданного пути есть символ /
#     Эта процедура состоит из нескольких шагов, так как в языке bash нельзя одной строкой проверить это.
#     Во-первых, развернем строку при помощи операции rev и сохраним результат в переменную pathrev
#     Во-вторых, осталось проверить, что лежит на первой позиции в переменной pathrev
#     Это делается при помощи среза. Реализовано в if-операторе
# Второй этап - удаление символа /, если он есть
#     Удалить последний символ можно уже одной командой, при помощи sed 's/.$//'

# Таким образом переворачиваем строку с путём
pathrev=$(rev <<< "$path")
# Если первый символ перевёрнутой строки это /, то в исходной переменной path надо удалить последний символ
if [ "${pathrev:0:1}" == '/' ]
then
    # Удаление последнего символа
    path=$(sed 's/.$//' <<< "$path")
fi

# Сохраняем заполненность папки в формате "x%"
percent=$(df $path | grep $path | awk '{ print $5}')

# Если пользователь передал папку с неограниченным размером
if [ "$percent" == "" ]
then
    percent="0%"
fi

# Удаление последнего символа "%"
percent=$(sed 's/.$//' <<< "$percent")

# Переходим в нужную папку
cd $path

# N = (кол-во файлов, находящихся в директории) / 2 и округление в большую сторону
N=$(( $(ls | wc -l) / 2 ))
ost=$(($(ls | wc -l)%2))
N=$((N + ost))

files_for_archive="" # Строка, куда будут записаны имена N самых старых файлов директории
if [ $percent -gt $parameter ]
then
    # При помощи ls сортируем файлы по дате изменения и записываем в массив files
    files_str=$(ls -tr) # Строка: lost+fount file1.txt file2.txt file3.txt
    files=($files_str) # Массив: {lost+fount, file1.txt, file2.txt, file3.txt}

    # При помощи цикла через пробел записываем имена N самых старых файлов в строку files_for_archive
    for((i=0; i<N; i++))
    do
        files_for_archive="$files_for_archive ${files[$i]}"
    done
    echo "Your directory is more than $parameter% full!"
    sudo tar czf archive.tar.gz $files_for_archive # Архивация
    echo "The archive was created!"
    sudo rm -r $files_for_archive # Удаление файлов из директории
fi
