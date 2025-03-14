*&---------------------------------------------------------------------*
*& REPORT ZCEB_CRUD_PRODUTO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCEB_CRUD_PRODUTO.

TABLES ZCEB_TB_PRODUTOS.

DATA: LV_COD_PRODUTO  TYPE ZCEB_TB_PRODUTOS-COD_DO_PRODUTO,
      LV_NOME_PRODUTO TYPE ZCEB_TB_PRODUTOS-NOME_DO_PRODUTO,
      LV_CATEGORIA    TYPE ZCEB_TB_PRODUTOS-CATEGORIA,
      LV_PRECO        TYPE ZCEB_TB_PRODUTOS-PRECO,
      LT_PRDT         LIKE ZCEB_TB_PRODUTOS OCCURS 0,
      LS_PRDT         LIKE LINE OF LT_PRDT.


SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: S_COD_P  FOR LV_COD_PRODUTO,
                S_NOME_P FOR LV_NOME_PRODUTO,
                S_CATETG FOR LV_CATEGORIA,
                S_PRECO  FOR LV_PRECO.
SELECTION-SCREEN END OF BLOCK  B1.


SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS S_COD_U    FOR LV_COD_PRODUTO.
PARAMETERS     P_PREC_N   TYPE ZCEB_TB_PRODUTOS-PRECO.
SELECTION-SCREEN END OF BLOCK  B2.


SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECT-OPTIONS: S_COD_D  FOR LV_COD_PRODUTO.
SELECTION-SCREEN END OF BLOCK  B3.





*ATIVIDADE 1
*TRAZENDO DADOS PARA O PROGRAMA
SELECT *
  FROM ZCEB_TB_PRODUTOS
  INTO TABLE LT_PRDT
  WHERE COD_DO_PRODUTO  IN S_COD_P
    AND NOME_DO_PRODUTO IN S_NOME_P
    AND CATEGORIA       IN S_CATETG
    AND PRECO           IN S_PRECO.


IF LT_PRDT IS INITIAL.

  APPEND VALUE #( COD_DO_PRODUTO = 1234567890   NOME_DO_PRODUTO =  'CELULAR'        CATEGORIA = 'ELETRO'    PRECO = '1234.89' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 1988792646   NOME_DO_PRODUTO =  'TENIS'          CATEGORIA = 'ROUPA'     PRECO = '105.00' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 2057330405   NOME_DO_PRODUTO =  'REFRIGERANTE'   CATEGORIA = 'ALIMENTOS' PRECO = '12.50' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 4104055808   NOME_DO_PRODUTO =  'GELADEIRA'      CATEGORIA = 'ELETRO'    PRECO = '3000.00' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 6334585306   NOME_DO_PRODUTO =  'RELOGIO'        CATEGORIA = 'ROUPAS'    PRECO = '250.55' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 6361031367   NOME_DO_PRODUTO =  'TECLADO'        CATEGORIA = 'ELETRO'    PRECO = '180.00' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 6552089486   NOME_DO_PRODUTO =  'MACA'           CATEGORIA = 'ALIMENTOS' PRECO = '1.50' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 7600836412   NOME_DO_PRODUTO =  'NOTEBOOK'       CATEGORIA = 'ELETRO'    PRECO = '3500.00' ) TO LT_PRDT.
  APPEND VALUE #( COD_DO_PRODUTO = 8430832389   NOME_DO_PRODUTO =  'SAIA'           CATEGORIA = 'ROUPAS'    PRECO = '70.00' ) TO LT_PRDT.


  WRITE |DADOS PASSADOS PARA A TABELA INTERNA|.


  IF LT_PRDT IS NOT INITIAL.
    LOOP AT LT_PRDT INTO LS_PRDT.
      INSERT INTO ZCEB_TB_PRODUTOS VALUES LS_PRDT.
      IF SY-SUBRC EQ 0.
        COMMIT WORK.
        WRITE / |PRODUTO { LS_PRDT-NOME_DO_PRODUTO } NO VALOR { LS_PRDT-PRECO } FOI ADICIONADO A TABELA|.
      ENDIF.
      CLEAR LS_PRDT.
    ENDLOOP.
  ENDIF.

  CLEAR LT_PRDT[].

ENDIF.


"ATIVIDADE 3
"ATUALIZANDO DADOS DA TABELA
SELECT SINGLE *
  FROM ZCEB_TB_PRODUTOS
  INTO LS_PRDT
  WHERE COD_DO_PRODUTO   IN S_COD_U.

IF LS_PRDT IS NOT INITIAL.
  UPDATE ZCEB_TB_PRODUTOS
    SET  PRECO = P_PREC_N
    WHERE COD_DO_PRODUTO = LS_PRDT-COD_DO_PRODUTO.

  IF SY-SUBRC EQ 0.
    COMMIT WORK.
    WRITE / |PRODUTO { LS_PRDT-NOME_DO_PRODUTO } TEVE O PRECO ATUALIZADO PARA R${ P_PREC_N }|.
    CLEAR: LS_PRDT, LT_PRDT.
  ENDIF.
ENDIF.

*ATIVIADADE 4
*DELETA DADO DA TABELA
SELECT SINGLE *
  FROM ZCEB_TB_PRODUTOS
  INTO LS_PRDT
  WHERE COD_DO_PRODUTO   IN S_COD_D.

IF LS_PRDT IS NOT INITIAL.
  DELETE FROM ZCEB_TB_PRODUTOS
   WHERE COD_DO_PRODUTO = LS_PRDT-COD_DO_PRODUTO.


  IF SY-SUBRC EQ 0 .
    COMMIT WORK.
    WRITE: / | PRODUTO { LS_PRDT-COD_DO_PRODUTO } - NOME { LS_PRDT-NOME_DO_PRODUTO } DELETADO|.
    CLEAR: LS_PRDT, LT_PRDT.
  ENDIF.
ENDIF.

*
*ATIVIDADE 5
*BUSCAR E EXIBIR DADOS NA TELA
SELECT *
  FROM ZCEB_TB_PRODUTOS
  INTO TABLE @DATA(LT_PRODUT)
  WHERE CATEGORIA       IN @S_CATETG.


IF LT_PRODUT IS NOT INITIAL.
  LOOP AT LT_PRODUT INTO DATA(WA_PRODUT).
    WRITE: / |CODIGO DO PRODUTO { WA_PRODUT-COD_DO_PRODUTO } - NOME { WA_PRODUT-NOME_DO_PRODUTO } - CATEGORIA { WA_PRODUT-CATEGORIA } PRECO R${ WA_PRODUT-PRECO }|.
    ULINE.
  ENDLOOP.
ENDIF.