REPORT Z_CEB_AJUSTE.

TYPES: BEGIN OF ty_cliente, "CRIANDO TYPOS DE TABELA
          MANDT      TYPE ZCEB_TAB_CLIENTE-MANDT,
          id_cliente type ZCEB_TAB_CLIENTE-ID_CLIENTE,
          nome       TYPE ZCEB_TAB_CLIENTE-NOME_CLIENTE,
          email      TYPE ZCEB_TAB_CLIENTE-EMAIL,
          data_cad   TYPE ZCEB_TAB_CLIENTE-DATA_CAD,
        END OF ty_cliente.

DATA: LT_CLIENTE TYPE TABLE OF TY_CLIENTE,   "CRIANDO UMA TABELA INTERNA
      LS_CLIENTE TYPE TY_CLIENTE.	             "CRINDO UMA ESTRUTURA

DELETE from ZCEB_TAB_CLIENTE.

SELECT * " BUSCA DADOS DA TABELA
  FROM ZCEB_TAB_CLIENTE
  INTO TABLE LT_CLIENTE.

IF SY-SUBRC ne 0. "VERIFICA SE O COMANDO FOI EXECUTADO CORRETAMENTE
  clear sy-subrc.
  APPEND VALUE #(  ID_CLIENTE = '001' NOME = 'CARLOS EDUARDO' "ADICIONA DADOS NA TABELA INTERNA
                  EMAIL = 'CARLOS@SOULCODE.COM' DATA_CAD = '20250226' ) TO LT_CLIENTE.

  APPEND VALUE #(  ID_CLIENTE = '002' NOME = 'JOSUE PERREIRA'
                  EMAIL = 'JOSUEPERREIRA@SOULCODE.COM' DATA_CAD = '20250112' ) TO LT_CLIENTE.

  APPEND VALUE #(  ID_CLIENTE = '003' NOME = 'CAIO VINI'
                  EMAIL = 'CAIOVINI@SOULCODE.COM' DATA_CAD = '20250201' ) TO LT_CLIENTE.

  APPEND VALUE #(  ID_CLIENTE = '004' NOME = 'SUELI COSTA'
                  EMAIL = 'SUELICOSTA@SOULCODE.COM' DATA_CAD = '20250205' ) TO LT_CLIENTE.

  IF SY-SUBRC EQ 0.
  LOOP AT LT_CLIENTE INTO LS_CLIENTE. "PERCORRE A TABELA INTERNA LINHA A LINHA
    WRITE / |CLIENTE { LS_CLIENTE-NOME } O ID: { LS_CLIENTE-ID_CLIENTE } FOI ADICIONADO A TABLEA|. "IMPRIME NA TELA OS VALORES
     INSERT INTO ZCEB_TAB_CLIENTE VALUES LS_CLIENTE. "ADICIONA DADOS NA TABELA DO BANCO DE DADOS


    ENDLOOP.
  ENDIF.
ENDIF.
SELECT-OPTIONS: S_ID FOR LV_ID_CLIENTE.

SELECT  *
  from ZCEB_TAB_CLIENTE
  INTO TABLE LT_CLIENTE
  WHERE ID_CLIENTE  IN S_ID.

IF LT_CLIENTE is NOT INITIAL.
*    UPDATE ZCEB_TAB_CLIENTE
*        SET EMAIL = 'CARLOSEDUARDO@SOULCODE.COM'
*        WHERE ID_CLIENTE = 1.



DELETE FROM ZCEB_TAB_CLIENTE
      WHERE ID_CLIENTE = LS_CLIENTE-ID_CLIENTE.

ELSE.
  MESSAGE 'ID NAO ENCONTRADO' TYPE 'E'.

ENDIF.TYOPESMA