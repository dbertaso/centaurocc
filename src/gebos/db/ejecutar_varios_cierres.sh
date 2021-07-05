#! /bin/bash
## Archivo batch que sera usado para controlar le ejecución del cierre por programa ##

echo "Comienza ejecución del cierre diario de cartera"

echo "Cantidad de días que será ejecutado el cierr:$1"

for ((j = 1; j < $1; j++))
do
  psql -Ugprotec -h 192.168.1.118 -p 5432 -fcontrol_shell.sql fondas_actual_rails3

  for ((i = 1; i <= 100; i++))
  do

  psql -Ugprotec -h 192.168.1.118 -p 5432 -fejecutar_cierre_diario.sql fondas_actual_rails3

  done
done
##psql -Ucartera -h localhost -fajustar_riesgo_y_provision_shell.sql gprotec_bandes_2
##psql -Ucartera -h localhost -fejecutar_cierre_financiero_shell.sql gprotec_bandes_2

