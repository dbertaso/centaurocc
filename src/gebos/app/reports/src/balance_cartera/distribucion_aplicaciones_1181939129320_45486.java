/*
 * Generated by JasperReports - 6/15/07 4:25 PM
 */
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.fill.*;

import java.util.*;
import java.math.*;
import java.text.*;
import java.io.*;
import java.net.*;

import java.util.*;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.*;


/**
 *
 */
public class distribucion_aplicaciones_1181939129320_45486 extends JREvaluator
{


    /**
     *
     */
    private JRFillParameter parameter_REPORT_RESOURCE_BUNDLE = null;
    private JRFillParameter parameter_p_fecha = null;
    private JRFillParameter parameter_REPORT_CLASS_LOADER = null;
    private JRFillParameter parameter_REPORT_FORMAT_FACTORY = null;
    private JRFillParameter parameter_REPORT_TIME_ZONE = null;
    private JRFillParameter parameter_REPORT_DATA_SOURCE = null;
    private JRFillParameter parameter_REPORT_LOCALE = null;
    private JRFillParameter parameter_REPORT_URL_HANDLER_FACTORY = null;
    private JRFillParameter parameter_REPORT_PARAMETERS_MAP = null;
    private JRFillParameter parameter_REPORT_CONNECTION = null;
    private JRFillParameter parameter_IS_IGNORE_PAGINATION = null;
    private JRFillParameter parameter_REPORT_VIRTUALIZER = null;
    private JRFillParameter parameter_REPORT_SCRIPTLET = null;
    private JRFillParameter parameter_REPORT_MAX_COUNT = null;
    private JRFillField field_id_solicitud = null;
    private JRFillField field_numero_factura = null;
    private JRFillField field_intereses = null;
    private JRFillField field_id_factura = null;
    private JRFillField field_id_prestamo = null;
    private JRFillField field_id_pago_prestamo = null;
    private JRFillField field_id_pago_cliente = null;
    private JRFillField field_capital_cuota = null;
    private JRFillField field_intereses_mora = null;
    private JRFillField field_capital = null;
    private JRFillField field_numero_cuota = null;
    private JRFillField field_nombre_empresa = null;
    private JRFillField field_fecha_aplicacion = null;
    private JRFillField field_proceso = null;
    private JRFillField field_id_pago_cuota = null;
    private JRFillField field_numero_credito = null;
    private JRFillField field_modalidad = null;
    private JRFillField field_numero_prestamo = null;
    private JRFillField field_intereses_cuota = null;
    private JRFillField field_monto_pago = null;
    private JRFillField field_monto_cuota = null;
    private JRFillField field_id_empresa = null;
    private JRFillField field_intereses_mora_cuota = null;
    private JRFillVariable variable_PAGE_NUMBER = null;
    private JRFillVariable variable_COLUMN_NUMBER = null;
    private JRFillVariable variable_REPORT_COUNT = null;
    private JRFillVariable variable_PAGE_COUNT = null;
    private JRFillVariable variable_COLUMN_COUNT = null;
    private JRFillVariable variable_factura_COUNT = null;
    private JRFillVariable variable_v_sum_capital_by_report = null;
    private JRFillVariable variable_v_sum_intereses_by_report = null;
    private JRFillVariable variable_v_sum_intereses_mora_by_report = null;
    private JRFillVariable variable_v_sum_monto_by_report = null;
    private JRFillVariable variable_v_proceso = null;
    private JRFillVariable variable_v_modalidad = null;
    private JRFillVariable variable_v_fecha = null;


    /**
     *
     */
    public void customizedInit(
        Map pm,
        Map fm,
        Map vm
        )
    {
        initParams(pm);
        initFields(fm);
        initVars(vm);
    }


    /**
     *
     */
    private void initParams(Map pm)
    {
        parameter_REPORT_RESOURCE_BUNDLE = (JRFillParameter)pm.get("REPORT_RESOURCE_BUNDLE");
        parameter_p_fecha = (JRFillParameter)pm.get("p_fecha");
        parameter_REPORT_CLASS_LOADER = (JRFillParameter)pm.get("REPORT_CLASS_LOADER");
        parameter_REPORT_FORMAT_FACTORY = (JRFillParameter)pm.get("REPORT_FORMAT_FACTORY");
        parameter_REPORT_TIME_ZONE = (JRFillParameter)pm.get("REPORT_TIME_ZONE");
        parameter_REPORT_DATA_SOURCE = (JRFillParameter)pm.get("REPORT_DATA_SOURCE");
        parameter_REPORT_LOCALE = (JRFillParameter)pm.get("REPORT_LOCALE");
        parameter_REPORT_URL_HANDLER_FACTORY = (JRFillParameter)pm.get("REPORT_URL_HANDLER_FACTORY");
        parameter_REPORT_PARAMETERS_MAP = (JRFillParameter)pm.get("REPORT_PARAMETERS_MAP");
        parameter_REPORT_CONNECTION = (JRFillParameter)pm.get("REPORT_CONNECTION");
        parameter_IS_IGNORE_PAGINATION = (JRFillParameter)pm.get("IS_IGNORE_PAGINATION");
        parameter_REPORT_VIRTUALIZER = (JRFillParameter)pm.get("REPORT_VIRTUALIZER");
        parameter_REPORT_SCRIPTLET = (JRFillParameter)pm.get("REPORT_SCRIPTLET");
        parameter_REPORT_MAX_COUNT = (JRFillParameter)pm.get("REPORT_MAX_COUNT");
    }


    /**
     *
     */
    private void initFields(Map fm)
    {
        field_id_solicitud = (JRFillField)fm.get("id_solicitud");
        field_numero_factura = (JRFillField)fm.get("numero_factura");
        field_intereses = (JRFillField)fm.get("intereses");
        field_id_factura = (JRFillField)fm.get("id_factura");
        field_id_prestamo = (JRFillField)fm.get("id_prestamo");
        field_id_pago_prestamo = (JRFillField)fm.get("id_pago_prestamo");
        field_id_pago_cliente = (JRFillField)fm.get("id_pago_cliente");
        field_capital_cuota = (JRFillField)fm.get("capital_cuota");
        field_intereses_mora = (JRFillField)fm.get("intereses_mora");
        field_capital = (JRFillField)fm.get("capital");
        field_numero_cuota = (JRFillField)fm.get("numero_cuota");
        field_nombre_empresa = (JRFillField)fm.get("nombre_empresa");
        field_fecha_aplicacion = (JRFillField)fm.get("fecha_aplicacion");
        field_proceso = (JRFillField)fm.get("proceso");
        field_id_pago_cuota = (JRFillField)fm.get("id_pago_cuota");
        field_numero_credito = (JRFillField)fm.get("numero_credito");
        field_modalidad = (JRFillField)fm.get("modalidad");
        field_numero_prestamo = (JRFillField)fm.get("numero_prestamo");
        field_intereses_cuota = (JRFillField)fm.get("intereses_cuota");
        field_monto_pago = (JRFillField)fm.get("monto_pago");
        field_monto_cuota = (JRFillField)fm.get("monto_cuota");
        field_id_empresa = (JRFillField)fm.get("id_empresa");
        field_intereses_mora_cuota = (JRFillField)fm.get("intereses_mora_cuota");
    }


    /**
     *
     */
    private void initVars(Map vm)
    {
        variable_PAGE_NUMBER = (JRFillVariable)vm.get("PAGE_NUMBER");
        variable_COLUMN_NUMBER = (JRFillVariable)vm.get("COLUMN_NUMBER");
        variable_REPORT_COUNT = (JRFillVariable)vm.get("REPORT_COUNT");
        variable_PAGE_COUNT = (JRFillVariable)vm.get("PAGE_COUNT");
        variable_COLUMN_COUNT = (JRFillVariable)vm.get("COLUMN_COUNT");
        variable_factura_COUNT = (JRFillVariable)vm.get("factura_COUNT");
        variable_v_sum_capital_by_report = (JRFillVariable)vm.get("v_sum_capital_by_report");
        variable_v_sum_intereses_by_report = (JRFillVariable)vm.get("v_sum_intereses_by_report");
        variable_v_sum_intereses_mora_by_report = (JRFillVariable)vm.get("v_sum_intereses_mora_by_report");
        variable_v_sum_monto_by_report = (JRFillVariable)vm.get("v_sum_monto_by_report");
        variable_v_proceso = (JRFillVariable)vm.get("v_proceso");
        variable_v_modalidad = (JRFillVariable)vm.get("v_modalidad");
        variable_v_fecha = (JRFillVariable)vm.get("v_fecha");
    }


    /**
     *
     */
    public Object evaluate(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.util.Date)(new java.sql.Date(2007,03,01));/*$JR_EXPR_ID=0$*/
                break;
            }
            case 1 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=1$*/
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=2$*/
                break;
            }
            case 3 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=3$*/
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=4$*/
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=5$*/
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=6$*/
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=7$*/
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=8$*/
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=9$*/
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=10$*/
                break;
            }
            case 11 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));/*$JR_EXPR_ID=11$*/
                break;
            }
            case 12 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));/*$JR_EXPR_ID=12$*/
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));/*$JR_EXPR_ID=13$*/
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));/*$JR_EXPR_ID=14$*/
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_proceso.getValue()).booleanValue()== true?"Nocturno":"Diurno");/*$JR_EXPR_ID=15$*/
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_modalidad.getValue()).equals("O")?"Taquilla":((java.lang.String)field_modalidad.getValue())=="R"?"Cta Recaudadora":((java.lang.String)field_modalidad.getValue())=="B"?"Banco Intermediado":"no aplica");/*$JR_EXPR_ID=16$*/
                break;
            }
            case 17 : 
            {
                value = (java.util.Date)(new java.util.Date(107,5,8));/*$JR_EXPR_ID=17$*/
                break;
            }
            case 18 : 
            {
                value = (java.util.Date)(new java.util.Date());/*$JR_EXPR_ID=18$*/
                break;
            }
            case 19 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_factura.getValue()));/*$JR_EXPR_ID=19$*/
                break;
            }
            case 20 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));/*$JR_EXPR_ID=20$*/
                break;
            }
            case 21 : 
            {
                value = (java.lang.Long)(((java.lang.Long)field_numero_prestamo.getValue()));/*$JR_EXPR_ID=21$*/
                break;
            }
            case 22 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getValue()));/*$JR_EXPR_ID=22$*/
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));/*$JR_EXPR_ID=23$*/
                break;
            }
            case 24 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_aplicacion.getValue()));/*$JR_EXPR_ID=24$*/
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));/*$JR_EXPR_ID=25$*/
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_credito.getValue()));/*$JR_EXPR_ID=26$*/
                break;
            }
            case 27 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));/*$JR_EXPR_ID=27$*/
                break;
            }
            case 28 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_factura.getValue()));/*$JR_EXPR_ID=28$*/
                break;
            }
            case 29 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_modalidad.getValue()));/*$JR_EXPR_ID=29$*/
                break;
            }
            case 30 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_proceso.getValue()));/*$JR_EXPR_ID=30$*/
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");/*$JR_EXPR_ID=31$*/
                break;
            }
            case 32 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));/*$JR_EXPR_ID=32$*/
                break;
            }
            case 33 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));/*$JR_EXPR_ID=33$*/
                break;
            }
            case 34 : 
            {
                value = (java.util.Date)(new Date());/*$JR_EXPR_ID=34$*/
                break;
            }
            case 35 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha.getValue()));/*$JR_EXPR_ID=35$*/
                break;
            }
            case 36 : 
            {
                value = (java.lang.String)("Cuota Número: " + ((java.lang.Integer)field_numero_cuota.getValue()));/*$JR_EXPR_ID=36$*/
                break;
            }
            case 37 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_cuota.getValue()));/*$JR_EXPR_ID=37$*/
                break;
            }
            case 38 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital_cuota.getValue()));/*$JR_EXPR_ID=38$*/
                break;
            }
            case 39 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_cuota.getValue()));/*$JR_EXPR_ID=39$*/
                break;
            }
            case 40 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora_cuota.getValue()));/*$JR_EXPR_ID=40$*/
                break;
            }
            case 41 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_monto_by_report.getValue()));/*$JR_EXPR_ID=41$*/
                break;
            }
            case 42 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_capital_by_report.getValue()));/*$JR_EXPR_ID=42$*/
                break;
            }
            case 43 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_by_report.getValue()));/*$JR_EXPR_ID=43$*/
                break;
            }
            case 44 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_mora_by_report.getValue()));/*$JR_EXPR_ID=44$*/
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


    /**
     *
     */
    public Object evaluateOld(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.util.Date)(new java.sql.Date(2007,03,01));/*$JR_EXPR_ID=0$*/
                break;
            }
            case 1 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=1$*/
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=2$*/
                break;
            }
            case 3 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=3$*/
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=4$*/
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=5$*/
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=6$*/
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=7$*/
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=8$*/
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=9$*/
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=10$*/
                break;
            }
            case 11 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getOldValue()));/*$JR_EXPR_ID=11$*/
                break;
            }
            case 12 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getOldValue()));/*$JR_EXPR_ID=12$*/
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getOldValue()));/*$JR_EXPR_ID=13$*/
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getOldValue()));/*$JR_EXPR_ID=14$*/
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_proceso.getOldValue()).booleanValue()== true?"Nocturno":"Diurno");/*$JR_EXPR_ID=15$*/
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_modalidad.getOldValue()).equals("O")?"Taquilla":((java.lang.String)field_modalidad.getOldValue())=="R"?"Cta Recaudadora":((java.lang.String)field_modalidad.getOldValue())=="B"?"Banco Intermediado":"no aplica");/*$JR_EXPR_ID=16$*/
                break;
            }
            case 17 : 
            {
                value = (java.util.Date)(new java.util.Date(107,5,8));/*$JR_EXPR_ID=17$*/
                break;
            }
            case 18 : 
            {
                value = (java.util.Date)(new java.util.Date());/*$JR_EXPR_ID=18$*/
                break;
            }
            case 19 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_factura.getOldValue()));/*$JR_EXPR_ID=19$*/
                break;
            }
            case 20 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getOldValue()));/*$JR_EXPR_ID=20$*/
                break;
            }
            case 21 : 
            {
                value = (java.lang.Long)(((java.lang.Long)field_numero_prestamo.getOldValue()));/*$JR_EXPR_ID=21$*/
                break;
            }
            case 22 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getOldValue()));/*$JR_EXPR_ID=22$*/
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getOldValue()));/*$JR_EXPR_ID=23$*/
                break;
            }
            case 24 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_aplicacion.getOldValue()));/*$JR_EXPR_ID=24$*/
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getOldValue()));/*$JR_EXPR_ID=25$*/
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_credito.getOldValue()));/*$JR_EXPR_ID=26$*/
                break;
            }
            case 27 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getOldValue()));/*$JR_EXPR_ID=27$*/
                break;
            }
            case 28 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_factura.getOldValue()));/*$JR_EXPR_ID=28$*/
                break;
            }
            case 29 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_modalidad.getOldValue()));/*$JR_EXPR_ID=29$*/
                break;
            }
            case 30 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_proceso.getOldValue()));/*$JR_EXPR_ID=30$*/
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");/*$JR_EXPR_ID=31$*/
                break;
            }
            case 32 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));/*$JR_EXPR_ID=32$*/
                break;
            }
            case 33 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));/*$JR_EXPR_ID=33$*/
                break;
            }
            case 34 : 
            {
                value = (java.util.Date)(new Date());/*$JR_EXPR_ID=34$*/
                break;
            }
            case 35 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha.getValue()));/*$JR_EXPR_ID=35$*/
                break;
            }
            case 36 : 
            {
                value = (java.lang.String)("Cuota Número: " + ((java.lang.Integer)field_numero_cuota.getOldValue()));/*$JR_EXPR_ID=36$*/
                break;
            }
            case 37 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_cuota.getOldValue()));/*$JR_EXPR_ID=37$*/
                break;
            }
            case 38 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital_cuota.getOldValue()));/*$JR_EXPR_ID=38$*/
                break;
            }
            case 39 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_cuota.getOldValue()));/*$JR_EXPR_ID=39$*/
                break;
            }
            case 40 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora_cuota.getOldValue()));/*$JR_EXPR_ID=40$*/
                break;
            }
            case 41 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_monto_by_report.getOldValue()));/*$JR_EXPR_ID=41$*/
                break;
            }
            case 42 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_capital_by_report.getOldValue()));/*$JR_EXPR_ID=42$*/
                break;
            }
            case 43 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_by_report.getOldValue()));/*$JR_EXPR_ID=43$*/
                break;
            }
            case 44 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_mora_by_report.getOldValue()));/*$JR_EXPR_ID=44$*/
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


    /**
     *
     */
    public Object evaluateEstimated(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.util.Date)(new java.sql.Date(2007,03,01));/*$JR_EXPR_ID=0$*/
                break;
            }
            case 1 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=1$*/
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=2$*/
                break;
            }
            case 3 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=3$*/
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=4$*/
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=5$*/
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=6$*/
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=7$*/
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=8$*/
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));/*$JR_EXPR_ID=9$*/
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));/*$JR_EXPR_ID=10$*/
                break;
            }
            case 11 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));/*$JR_EXPR_ID=11$*/
                break;
            }
            case 12 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));/*$JR_EXPR_ID=12$*/
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));/*$JR_EXPR_ID=13$*/
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));/*$JR_EXPR_ID=14$*/
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_proceso.getValue()).booleanValue()== true?"Nocturno":"Diurno");/*$JR_EXPR_ID=15$*/
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.String)field_modalidad.getValue()).equals("O")?"Taquilla":((java.lang.String)field_modalidad.getValue())=="R"?"Cta Recaudadora":((java.lang.String)field_modalidad.getValue())=="B"?"Banco Intermediado":"no aplica");/*$JR_EXPR_ID=16$*/
                break;
            }
            case 17 : 
            {
                value = (java.util.Date)(new java.util.Date(107,5,8));/*$JR_EXPR_ID=17$*/
                break;
            }
            case 18 : 
            {
                value = (java.util.Date)(new java.util.Date());/*$JR_EXPR_ID=18$*/
                break;
            }
            case 19 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_factura.getValue()));/*$JR_EXPR_ID=19$*/
                break;
            }
            case 20 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_pago.getValue()));/*$JR_EXPR_ID=20$*/
                break;
            }
            case 21 : 
            {
                value = (java.lang.Long)(((java.lang.Long)field_numero_prestamo.getValue()));/*$JR_EXPR_ID=21$*/
                break;
            }
            case 22 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getValue()));/*$JR_EXPR_ID=22$*/
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital.getValue()));/*$JR_EXPR_ID=23$*/
                break;
            }
            case 24 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_aplicacion.getValue()));/*$JR_EXPR_ID=24$*/
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora.getValue()));/*$JR_EXPR_ID=25$*/
                break;
            }
            case 26 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_credito.getValue()));/*$JR_EXPR_ID=26$*/
                break;
            }
            case 27 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses.getValue()));/*$JR_EXPR_ID=27$*/
                break;
            }
            case 28 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_factura.getValue()));/*$JR_EXPR_ID=28$*/
                break;
            }
            case 29 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_modalidad.getEstimatedValue()));/*$JR_EXPR_ID=29$*/
                break;
            }
            case 30 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_proceso.getEstimatedValue()));/*$JR_EXPR_ID=30$*/
                break;
            }
            case 31 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");/*$JR_EXPR_ID=31$*/
                break;
            }
            case 32 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));/*$JR_EXPR_ID=32$*/
                break;
            }
            case 33 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));/*$JR_EXPR_ID=33$*/
                break;
            }
            case 34 : 
            {
                value = (java.util.Date)(new Date());/*$JR_EXPR_ID=34$*/
                break;
            }
            case 35 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha.getValue()));/*$JR_EXPR_ID=35$*/
                break;
            }
            case 36 : 
            {
                value = (java.lang.String)("Cuota Número: " + ((java.lang.Integer)field_numero_cuota.getValue()));/*$JR_EXPR_ID=36$*/
                break;
            }
            case 37 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_cuota.getValue()));/*$JR_EXPR_ID=37$*/
                break;
            }
            case 38 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_capital_cuota.getValue()));/*$JR_EXPR_ID=38$*/
                break;
            }
            case 39 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_cuota.getValue()));/*$JR_EXPR_ID=39$*/
                break;
            }
            case 40 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_intereses_mora_cuota.getValue()));/*$JR_EXPR_ID=40$*/
                break;
            }
            case 41 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_monto_by_report.getEstimatedValue()));/*$JR_EXPR_ID=41$*/
                break;
            }
            case 42 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_capital_by_report.getEstimatedValue()));/*$JR_EXPR_ID=42$*/
                break;
            }
            case 43 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_by_report.getEstimatedValue()));/*$JR_EXPR_ID=43$*/
                break;
            }
            case 44 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_intereses_mora_by_report.getEstimatedValue()));/*$JR_EXPR_ID=44$*/
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


}
