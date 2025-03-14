REPORT ZCEB_SQL_AVC.

TABLES: SPFLI, SFLIGHT.

SELECT-OPTIONS S_CARRID FOR SPFLI-CARRID.
SELECT-OPTIONS S_CONNID FOR SPFLI-CONNID.
SELECT-OPTIONS S_FLDATE FOR SFLIGHT-FLDATE.



TYPES: BEGIN OF TY_VOOS,
            CARRID      TYPE SPFLI-CARRID,
            CONNID      TYPE SPFLI-CONNID,
            COUNTRYFR   TYPE SPFLI-COUNTRYFR,
            CITYFROM    TYPE SPFLI-CITYFROM,
            AIRPFROM    TYPE SPFLI-AIRPFROM,
            COUNTRYTO   TYPE SPFLI-COUNTRYTO,
            DISTANCE    TYPE SPFLI-DISTANCE,
            FLDATE      TYPE SFLIGHT-FLDATE,
            PRICE       TYPE SFLIGHT-PRICE,
            CURRENCY    TYPE SFLIGHT-CURRENCY,
            PLANETYPE   TYPE SFLIGHT-PLANETYPE,
            SEATSMAX    TYPE SFLIGHT-SEATSMAX,

        END OF TY_VOOS.

DATA: GT_VOOS TYPE TABLE OF TY_VOOS.
DATA: GS_VOOS TYPE TY_VOOS.

TYPES: BEGIN OF TS_SPFLI,
        CARRID    TYPE SPFLI-CARRID,
        CONNID    TYPE SPFLI-CONNID,
        COUNTRYFR TYPE SPFLI-COUNTRYFR,
        CITYFROM  TYPE SPFLI-CITYFROM,
        AIRPFROM  TYPE SPFLI-AIRPFROM,
        COUNTRYTO TYPE SPFLI-COUNTRYTO,
        DISTANCE  TYPE SPFLI-DISTANCE,
        END OF TS_SPFLI.


TYPES: BEGIN OF TS_SFLIGHT,
        CARRID    TYPE SFLIGHT-CARRID,
        CONNID    TYPE SFLIGHT-CONNID,
        FLDATE    TYPE SFLIGHT-FLDATE,
        PRICE     TYPE SFLIGHT-PRICE,
        CURRENCY  TYPE SFLIGHT-CURRENCY,
        PLANETYPE TYPE SFLIGHT-PLANETYPE,
        SEATSMAX  TYPE SFLIGHT-SEATSMAX,
        END OF TS_SFLIGHT.


DATA:   GT_SPFLI   TYPE TABLE OF TS_SPFLI,
        GT_SFLIGHT TYPE TABLE OF TS_SFLIGHT.

*  SELECT A~CARRID, A~CONNID,A~COUNTRYFR,
*         A~CITYFROM, A~AIRPFROM,A~COUNTRYTO,
*         A~DISTANCE, B~FLDATE, B~PRICE,
*         B~CURRENCY, B~PLANETYPE, B~SEATSMAX
*    FROM SPFLI AS A  INNER JOIN SFLIGHT AS B
*          ON  A~CARRID EQ B~CARRID
*          AND A~CONNID EQ B~CONNID
*      WHERE A~CARRID EQ @S_CARRID
*        AND A~CONNID EQ @P_CONNID
*        AND B~FLDATE EQ @S_FLDATE
*      INTO CORRESPONDING FIELDS OF TABLE @GT_VOOS.

*IF S_CARRID IS NOT INITIAL AND S_CONNID IS NOT INITIAL.

  SELECT CARRID
         CONNID
         COUNTRYFR
         CITYFROM
         AIRPFROM
         COUNTRYTO
         DISTANCE
  FROM SPFLI
  INTO TABLE GT_SPFLI.
*  WHERE CARRID IN S_CARRID
*    AND CONNID IN S_CONNID.


  IF GT_SPFLI IS NOT INITIAL.

    SELECT CARRID,
           CONNID,
           FLDATE,
           PRICE,
           CURRENCY,
           PLANETYPE,
           SEATSMAX
      FROM SFLIGHT
      INTO TABLE @GT_SFLIGHT
      FOR ALL ENTRIES IN @GT_SPFLI
        WHERE CARRID  = @GT_SPFLI-CARRID
          AND CONNID  = @GT_SPFLI-CONNID
          AND FLDATE  IN @S_FLDATE.


    SORT GT_SPFLI  BY CARRID CONNID.
    SORT GT_SFLIGHT BY CARRID CONNID.


  LOOP AT GT_SPFLI INTO DATA(GS_SPFLI).
      READ TABLE GT_SFLIGHT INTO DATA(GS_SFLIGHT) WITH KEY CARRID = GS_SPFLI-CARRID
                                                           CONNID = GS_SPFLI-CONNID.

      IF SY-SUBRC EQ 0.
          MOVE-CORRESPONDING GS_SFLIGHT TO GS_VOOS.
          MOVE-CORRESPONDING GS_SPFLI   TO GS_VOOS.
          APPEND  GS_VOOS TO GT_VOOS.
      ENDIF.
  ENDLOOP.

  ENDIF.




*ENDIF.