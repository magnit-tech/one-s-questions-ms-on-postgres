CREATE EVENT SESSION [ИМЯ_СЕАНСА_РАСШИРЕННЫХ_СОБЫТИЙ] ON SERVER
ADD
    EVENT sqlserver.rpc_completed(
        ACTION(package0.event_sequence, sqlserver.session_id)
        WHERE
            (
                [sqlserver].[equal_i_sql_unicode_string]([sqlserver].[database_name], N'ИМЯ_БАЗЫ')
                AND NOT [sqlserver].[like_i_sql_unicode_string]([statement], N'%FROM dbo._ScheduledJobs%')
                AND NOT [sqlserver].[like_i_sql_unicode_string](
                    [statement],
                    N'%DELETE FROM%'
                )
                AND NOT [sqlserver].[like_i_sql_unicode_string](
                    [statement],
                    N '%INSERT INTO dbo.%'
                )
                AND NOT [sqlserver].[like_i_sql_unicode_string]([statement], N'% FROM Config WHERE %')
            )
    ),
ADD
    EVENT sqlserver.sql_batch_completed(
        SET
            collect_batch_text =(1) ACTION(package0.event_sequence, sqlserver.session_id)
        WHERE
            (
                [sqlserver].[equal_i_sql_unicode_string]([sqlserver].[database_name], N'ИМЯ_БАЗЫ')
                AND NOT [sqlserver].[like_i_sql_unicode_string]([batch_text], N '%TRANSACTION%')
            )
    )
ADD
    TARGET package0.event_file(
        SET
            filename = N'ПУТЬ_К_ФАЙЛУ_ЛОГОВ.xel',
            max_file_size =(1024),
            max_rollover_files =(200)
    ) WITH (
        MAX_MEMORY = 4096 KB,
        EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
        MAX_DISPATCH_LATENCY = 30 SECONDS,
        MAX_EVENT_SIZE = 0 KB,
        MEMORY_PARTITION_MODE = NONE,
        TRACK_CAUSALITY = ON,
        STARTUP_STATE = OFF
    )
GO