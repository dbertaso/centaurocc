#! /bin/bash
## Archivo batch que sera usado para controlar le ejecución del cierre por programa ##

echo "Comienza ejecución del cierre diario de cartera"
psql -Ugprotec -h 192.168.1.118 -p 5432 -fcontrol_shell.sql fondas_actual_rails3
#psql -Udbertaso -h localhost -p 5434 -fcontrol_shell.sql fondas_actual_tasa

for ((i = 1; i <= 25; i++))
  do

    psql -Ugprotec -h 192.168.1.118 -p 5432 -fejecutar_cierre_diario.sql fondas_actual_rails3
    #psql -Udbertaso -h 192.168.1.118 -p 5432 -fejecutar_cierre_diario.sql fondas_actual_tasa
  done
#psql -Udbertaso -h localhost -p 5434 -fajustar_riesgo_y_provision_shell.sql fondas_actual_rails3
#psql -Udbertaso -h localhost -p 5434 -fejecutar_cierre_financiero_shell.sql fondas_actual_rails3
