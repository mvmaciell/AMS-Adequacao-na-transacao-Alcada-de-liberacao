INCLUDE zsd_workflow_top. 

TYPES: BEGIN OF ty_alv_hd,

 lv_total_m3 TYPE ekpo-menge,            " OCN.SD.MV..3142 Adequação na Transação ZSD022
 edatu       TYPE vbep-edatu.            " OCN.SD.MV..3142 Adequação na Transação ZSD022

 DATA: del_data TYPE vbep-edatu.         " OCN.SD.MV..3142 Adequação na Transação ZSD022

 TYPES   END OF ty_alv_hd.

INCLUDE zsd_workflow_f01.

* Adiciona o total m3 na tabela hd       * OCN.SD.MV..3142 Adequação na Transação ZSD0227 INI -----------------------

      DATA(lwa_it) = <fs_it_aux>.
      IF lwa_it-fkrel = 'A'.

        " Calcula o m3 para o item atual
        PERFORM m3 USING lwa_it-kwmeng lwa_it-matnr lwa_it-vrkme CHANGING lwa_it-m3.

        " Adiciona o m3 do item atual ao total
        <fs_hd>-lv_total_m3 = <fs_hd>-lv_total_m3 + lwa_it-m3.
      ENDIF.

* Adiciona o total m3 na tabela hd       * OCN.SD.MV..3142 Adequação na Transação ZSD0227 FIM -----------------------

* Preencher data remessa                 * OCN.SD.MV..3142 Adequação na Transação ZSD0227 INI -----------------------

    CLEAR del_data.

    LOOP AT t_alv_it_aux INTO DATA(wa_alv_it_aux) WHERE vbeln = <fs_hd>-vbeln.

      IF wa_alv_it_aux-edatu < del_data OR del_data IS INITIAL .

        del_data = wa_alv_it_aux-edatu.

      ENDIF.

    ENDLOOP.

    <fs_hd>-edatu = del_data.

* Preencher data remessa                 * OCN.SD.MV..3142 Adequação na Transação ZSD0227 FIM -----------------------

FORM fieldcat_hd.
  CLEAR g_colpos.
  PERFORM add_fieldcat_alv_hd_0100 USING:
  
        'LV_TOTAL_M3'     ' '       ' '      ' '        'Volume',     " OCN.SD.MV..3142 Adequação na Transação ZSD022
        'EDATU'           ' '       ' '      ' '        'Dt.Remessa', " OCN.SD.MV..3142 Adequação na Transação ZSD022