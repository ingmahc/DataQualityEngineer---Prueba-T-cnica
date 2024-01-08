/*
<Creado por>
	Miguel Angel Herrera Castro
	Tecnólogo en Desarrollo de Software


<Descripcion>
	SP para importación de archito csv desde una ubicación establecida
<Tipo_SP>
	Extraction-Transformation-Load
<Pamametros>
	No utiliza parametros de entrada
<Tipo_Resultado>
	Vallidación del archivo importado
	Insert en tb tbRawImportCsv
				 tbValImportCsvSpotify
				 tbNULLErrorsImport
				 tbRangeErrorsImport
				 tbTypeErrorsImport
<Resultado>
	tb con resultado de validaciones
	Insert en tb física

<Ejemplo>
	Ejemplo de como ejecutar el SP EXEC dbo.spImportSpotifyDataSetCsv


*/

CREATE OR ALTER PROCEDURE dbo.spImportSpotifyDataSetCsv
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

		-- Variables de configuración
		DECLARE @FolderPath NVARCHAR(255)	= 'C:\Users\ingma\Documents\Prueba_tecnica_R5\';
		DECLARE @FileName NVARCHAR(255)		= 'dataset.csv';
		DECLARE @TableName NVARCHAR(255)	= '#ImportCsv'

		-- Construir la ruta completa del archivo
		DECLARE @FullPath NVARCHAR(255);
		SET @FullPath = @FolderPath + @FileName;

		DROP TABLE IF EXISTS #ImportCsv
		CREATE TABLE #ImportCsv
			(
			disc_number							NVARCHAR(200)
			,duration_ms						NVARCHAR(200)
			,[explicit]							NVARCHAR(200)
			,track_number						NVARCHAR(200)
			,track_popularity					NVARCHAR(200)
			,track_id							NVARCHAR(200)
			,track_name							NVARCHAR(200)
			,audio_features_danceability		NVARCHAR(200)
			,audio_features_energy				NVARCHAR(200)
			,audio_features_key					NVARCHAR(200)
			,audio_features_loudness			NVARCHAR(200)
			,audio_features_mode				NVARCHAR(200)
			,audio_features_speechiness			NVARCHAR(200)
			,audio_features_acousticness		NVARCHAR(200)
			,audio_features_instrumentalness	NVARCHAR(200)
			,audio_features_liveness			NVARCHAR(200)
			,audio_features_valence				NVARCHAR(200)
			,audio_features_tempo				NVARCHAR(200)
			,audio_features_id					NVARCHAR(200)
			,audio_features_time_signature		NVARCHAR(200)
			,artist_id							NVARCHAR(200)
			,artist_name						NVARCHAR(200)
			,artist_popularity					NVARCHAR(200)
			,album_id							NVARCHAR(200)
			,album_name							NVARCHAR(200)
			,album_release_date					NVARCHAR(200)
			,album_total_tracks					NVARCHAR(200)
			)

		-- Comando BULK INSERT para importar el archivo CSV en la tabla
		DECLARE @SqlCmd NVARCHAR(MAX);
		SET @SqlCmd = '
						BULK INSERT ' + @TableName + '
						FROM ''' + @FullPath + '''
						WITH (
							FIELDQUOTE = ''"'',
							FIELDTERMINATOR = '';'',
							ROWTERMINATOR = ''\n'',
							FIRSTROW = 2,
							CODEPAGE = ''1252''

						)';
		-- Ejecutar el comando BULK INSERT
		EXEC sp_executesql @SqlCmd;
		
	
		IF OBJECT_ID('tempdb..#Validation') IS NOT NULL
		CREATE TABLE #Validation
			(
			disc_number							INT
			,duration_ms						INT
			,[explicit]							NVARCHAR(200)
			,track_number						NVARCHAR(200)
			,track_popularity					NVARCHAR(200)
			,track_id							NVARCHAR(200)
			,track_name							NVARCHAR(200)
			,audio_features_danceability		NVARCHAR(200)
			,audio_features_energy				NVARCHAR(200)
			,audio_features_key					NVARCHAR(200)
			,audio_features_loudness			NVARCHAR(200)
			,audio_features_mode				NVARCHAR(200)
			,audio_features_speechiness			NVARCHAR(200)
			,audio_features_acousticness		NVARCHAR(200)
			,audio_features_instrumentalness	NVARCHAR(200)
			,audio_features_liveness			NVARCHAR(200)
			,audio_features_valence				NVARCHAR(200)
			,audio_features_tempo				NVARCHAR(200)
			,audio_features_id					NVARCHAR(200)
			,audio_features_time_signature		NVARCHAR(200)
			,artist_id							NVARCHAR(200)
			,artist_name						NVARCHAR(200)
			,artist_popularity					NVARCHAR(200)
			,album_id							NVARCHAR(200)
			,album_name							NVARCHAR(200)
			,album_release_date					NVARCHAR(200)
			,album_total_tracks					NVARCHAR(200)
			,NUM								INT
			)
	
	
		-- Insertar datos en tbRawImportCsv
		TRUNCATE TABLE tbRawImportCsv

		INSERT INTO tbRawImportCsv
		SELECT 
			disc_number							
			,duration_ms						
			,[explicit]							
			,track_number						
			,track_popularity					
			,track_id							
			,track_name							
			,audio_features_danceability		
			,audio_features_energy				
			,audio_features_key					
			,audio_features_loudness			
			,audio_features_mode				
			,audio_features_speechiness			
			,audio_features_acousticness		
			,audio_features_instrumentalness	
			,audio_features_liveness			
			,audio_features_valence				
			,audio_features_tempo				
			,audio_features_id					
			,audio_features_time_signature		
			,artist_id							
			,artist_name						
			,artist_popularity					
			,album_id							
			,album_name							
			,album_release_date					
			,album_total_tracks
			,ROW_NUMBER() OVER(ORDER BY disc_number ASC) NUM
		FROM #ImportCsv

		-- Insertar datos en #Validation
		INSERT INTO #Validation
		SELECT 
			disc_number							
			,duration_ms						
			,[explicit]							
			,track_number						
			,track_popularity					
			,track_id							
			,track_name							
			,audio_features_danceability		
			,audio_features_energy				
			,audio_features_key					
			,audio_features_loudness			
			,audio_features_mode				
			,audio_features_speechiness			
			,audio_features_acousticness		
			,audio_features_instrumentalness	
			,audio_features_liveness			
			,audio_features_valence				
			,audio_features_tempo				
			,audio_features_id					
			,audio_features_time_signature		
			,artist_id							
			,artist_name						
			,artist_popularity					
			,album_id							
			,album_name							
			,album_release_date					
			,album_total_tracks
			,ROW_NUMBER() OVER(ORDER BY disc_number ASC) NUM
		FROM #ImportCsv


		/*validacion de  
				T (Type)	: Validación si el tipo de dato es correcto 
				R (Range)	: Validacion si el rango se ajusta al dato
				N (Nulls)	: Validacion de campos vacios
		*/
	
		--Insersión de validacionea en tbValImportCsvSpotify realizadas a la tb temporal #Validation
		INSERT INTO dbo.tbValImportCsvSpotify
		SELECT 
		
			NUM
			,case when Try_convert(int,disc_number,0) > 0 then 1 
					else 0 end as Tdisc_number
			,case when convert(int,disc_number) >= 0 then 1 else 0 end as Rdisc_number
			,dbo.CheckNotNullAsOne(disc_number) Ndisc_number

			,case when Try_convert(int,duration_ms,0) > 0 then 1 else 0 end as Tduration_ms
			,case when convert(int,duration_ms) >= 0 then 1 else 0 end as Rduration_ms
			,dbo.CheckNotNullAsOne(duration_ms)	Nduration_ms	

			,case when Try_convert(bit,explicit,0) is null then 0 else 1 end as Talexplicit
			,case when Try_convert(bit,explicit) = 'True' or Try_convert(bit,explicit) = 'False' then 1 else 0 end as Rexplicit
			,dbo.CheckNotNullAsOne([explicit]) Nexplicit

			,case when Try_convert(int,track_number,0) > 0 then 1 else 0 end as Ttrack_number
			,case when convert(int,track_number) >= 0 then 1 else 0 end as Rtrack_number
			,dbo.CheckNotNullAsOne(track_number) Ntrack_number

			,case when Try_convert(int,track_popularity,0) >= 0 then 1 else 0 end as Ttrack_popularity
			,case when Try_convert(int,track_popularity) between 0 and 100 then 1 else 0 end as Rtrack_popularity
			,dbo.CheckNotNullAsOne(track_popularity) Ntrack_popularity

			,case when Try_convert(nvarchar,track_id,0)  is null then 0 else 1 end as Ttrack_id
			,dbo.CheckNotNullAsOne(track_id) Ntrack_id	
		
			,case when Try_convert(nvarchar,track_name,0) is null then 0 else 1 end as Ttrack_name
			,dbo.CheckNotNullAsOne(track_name) Ntrack_name

			,case when Try_convert(float,audio_features_danceability,0) > 0 then 1 else 0 end as  Taudio_features_danceability
			,case when Try_convert(float,audio_features_danceability) between 0.0 and 1.0 then 1 else 0 end as Raudio_features_danceability
			,dbo.CheckNotNullAsOne(audio_features_danceability) Naudio_features_danceability

			,case when Try_convert(float,audio_features_energy,0) > 0 then 1 else 0 end as  Taudio_features_energy
			,case when Try_convert(float,audio_features_energy) between 0.0 and 1.0 then 1 else 0 end as Raudio_features_energy
			,dbo.CheckNotNullAsOne(audio_features_energy) Naudio_features_energy

			,case when Try_convert(float,audio_features_key,0) >= 0 then 1 else 0 end as  Taudio_features_key
			,case when Try_convert(float,audio_features_key) between -1 and 11 then 1 else 0 end as Raudio_features_key
			,dbo.CheckNotNullAsOne(audio_features_key)	Naudio_features_key

			,case when Try_convert(float,audio_features_loudness,0) between -60 and 0 then 1 else 0 end as Taudio_features_loudness
			,case when Try_convert(float,audio_features_loudness) between -60 and 0 then 1 else 0 end as Raudio_features_loudness
			,dbo.CheckNotNullAsOne(audio_features_loudness)	Naudio_features_loudness	

			,case when Try_convert(int,audio_features_mode,0) >= 0 then 1 else 0 end as Taudio_features_mode
			,case when Try_convert(int,audio_features_mode) between 0 and 1 then 1 else 0 end as Raudio_features_mode
			,dbo.CheckNotNullAsOne(audio_features_mode)	Naudio_features_mode	

			,case when Try_convert(float,audio_features_speechiness,0) >= 0 then 1 else 0 end as Taudio_features_speechiness
			,case when Try_convert(float,audio_features_speechiness) between 0.0 and 1.0 then 1 else 0 end as Raudio_features_speechiness
			,dbo.CheckNotNullAsOne(audio_features_speechiness)	Naudio_features_speechiness

			,case when Try_convert(float,audio_features_acousticness,0) >= 0 then 1 else 0 end as Taudio_features_acousticness
			,case when Try_convert(float,audio_features_acousticness) between 0.0 and 1.0 then 1 else 0 end as Raudio_features_acousticness
			,dbo.CheckNotNullAsOne(audio_features_acousticness)	Naudio_features_acousticness

			,case when Try_convert(float,audio_features_instrumentalness,0) >= 0 then 1 else 0 end as Taudio_features_instrumentalness
			,case when Try_convert(float,audio_features_instrumentalness) between 0.0 and 1.0 then 1 else 0 end as Raudio_features_instrumentalness
			,dbo.CheckNotNullAsOne(audio_features_instrumentalness)	Naudio_features_instrumentalness

			,case when Try_convert(float,audio_features_liveness,0) >= 0 then 1 else 0 end as Taudio_features_liveness
			,case when Try_convert(float,audio_features_liveness) between 0.0 and 1.0 then 1 else 0 end as Raudio_features_liveness
			,dbo.CheckNotNullAsOne(audio_features_liveness)	audio_features_liveness	

			,case when Try_convert(float,audio_features_valence,0) >= 0 then 1 else 0 end as Taudio_features_valence
			,case when Try_convert(float,audio_features_valence) between 0.0 and 1.0 then 1 else 0 end as Raudio_features_valence
			,dbo.CheckNotNullAsOne(audio_features_valence)	Naudio_features_valence

			,case when Try_convert(float,audio_features_tempo,0) >= 0 then 1 else 0 end as Taudio_features_tempo
			,case when Try_convert(float,audio_features_tempo) >= 0 then 1 else 0 end as Raudio_features_tempo
			,dbo.CheckNotNullAsOne(audio_features_tempo) Naudio_features_tempo

			,case when Try_convert(nvarchar,audio_features_id,0) is null then 0 else 1 end as Taudio_features_id
			,dbo.CheckNotNullAsOne(audio_features_id) Naudio_features_id	

			,case when Try_convert(float,audio_features_time_signature,0) >= 0 then 1 else 0 end as Taudio_features_time_signature
			,case when Try_convert(float,audio_features_time_signature) between  3 and 7 then 1 else 0 end as Raudio_features_time_signature		
			,dbo.CheckNotNullAsOne(audio_features_time_signature) Naudio_features_time_signature

			,case when Try_convert(nvarchar,artist_id,0) is null then 0 else 1 end as Tartist_id
			,dbo.CheckNotNullAsOne(artist_id) Nartist_id

			,case when Try_convert(nvarchar,artist_name,0) is null then 0 else 1 end as Tartist_name
			,dbo.CheckNotNullAsOne(artist_name) Nartist_name

			,case when Try_convert(int,artist_popularity,0) >= 0 then 1 else 0 end as Tartist_popularity
			,case when Try_convert(int,artist_popularity) between 0 and 100 then 1 else 0 end as Rartist_popularity
			,dbo.CheckNotNullAsOne(artist_popularity) Nartist_popularity	

			,case when Try_convert(nvarchar,album_id,0) is null then 0 else 1 end as Talbum_id
			,dbo.CheckNotNullAsOne(album_id) Nalbum_id

			,case when Try_convert(nvarchar,album_name,0) is null then 0 else 1 end as Talbum_name
			,dbo.CheckNotNullAsOne(album_name) Nalbum_name

			,case when Try_convert(date,album_release_date,0) > '1901-01-01' then 1 else 0 end as Talbum_release_date
			,case when Try_convert(date,album_release_date) between '2006-01-01' and cast(getdate() as date) then 1 else 0 end as Ralbum_release_date
			,dbo.CheckNotNullAsOne(album_release_date) Nalbum_release_date

			,case when Try_convert(int,album_total_tracks,0) > 0 then 1 else 0 end as Talbum_total_tracks
			,case when Try_convert(int,album_total_tracks) >= 0 then 1 else 0 end as Ralbum_total_tracks
			,dbo.CheckNotNullAsOne(album_total_tracks) Nalbum_total_tracks
			,GETDATE() 
		FROM #Validation 


		-- Inserción de datos en tbNULLErrorsImport, tbRangeErrorsImport y tbTypeErrorsImport utilizando la cláusula PIVOT

		INSERT INTO tbRangeErrorsImport
		SELECT
			Columna,
			RangeErrors
		 
		FROM (
			SELECT 
				'disc_number' AS Columna,
				CONVERT(int, MAX([NUM]) - SUM([Rdisc_number])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION ALL

			SELECT 
				'duration_ms' AS Columna,
				CONVERT(int, MAX([NUM]) - SUM([Rduration_ms])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]
			UNION

			SELECT 
				'explicit' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Rexplicit])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]
	
			UNION
			SELECT 
				'track_number' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Rtrack_number])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'track_popularity' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Rtrack_popularity])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			--UNION
		 --   SELECT 
		 --       'track_id' AS Columna,
			--	 CONVERT(int, max([NUM]) - sum([Ntrack_id])) AS RangeErrors
			--FROM [dbo].[tbValImportCsvSpotify]

			--UNION
		 --   SELECT 
		 --       'track_name' AS Columna,
			--	 CONVERT(int, max([NUM]) - sum([Ntrack_name])) AS RangeErrors
			--FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_danceability' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_danceability])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_energy' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_energy])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_key' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_key])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_loudness' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_loudness])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_mode' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_mode])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]


			UNION
			SELECT 
				'audio_features_speechiness' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_speechiness])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_acousticness' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_acousticness])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_instrumentalness' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_instrumentalness])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_liveness' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_liveness])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_valence' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_valence])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

			UNION
			SELECT 
				'audio_features_tempo' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_tempo])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

		 --	UNION
		 --   SELECT 
		 --       'audio_features_id' AS Columna,
			--	 CONVERT(int, max([NUM]) - sum([Naudio_features_id])) AS RangeErrors
			--FROM [dbo].[tbValImportCsvSpotify]

 			UNION
			SELECT 
				'audio_features_time_signature' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Raudio_features_time_signature])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

		 --	UNION
		 --   SELECT 
		 --       'artist_id' AS Columna,
			--	 CONVERT(int, max([NUM]) - sum([Nartist_id])) AS RangeErrors
			--FROM [dbo].[tbValImportCsvSpotify]


		 --	UNION
		 --   SELECT 
		 --       'artist_name' AS Columna,
			--	 CONVERT(int, max([NUM]) - sum([Nartist_name])) AS RangeErrors
			--FROM [dbo].[tbValImportCsvSpotify]

 			UNION
			SELECT 
				'artist_popularity' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Rartist_popularity])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

		 --	UNION
		 --   SELECT 
		 --       'album_id' AS Columna,
			--	 CONVERT(int, max([NUM]) - sum([Nalbum_id])) AS RangeErrors
			--FROM [dbo].[tbValImportCsvSpotify]

		 --	UNION
		 --   SELECT 
		 --       'album_name' AS Columna,
			--	 CONVERT(int, max([NUM]) - sum([Nalbum_name])) AS RangeErrors
			--FROM [dbo].[tbValImportCsvSpotify]

 			UNION
			SELECT 
				'album_release_date' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Ralbum_release_date])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]

 			UNION
			SELECT 
				'album_total_tracks' AS Columna,
				 CONVERT(int, max([NUM]) - sum([Ralbum_total_tracks])) AS RangeErrors
			FROM [dbo].[tbValImportCsvSpotify]



		) AS PivotData


      -- Confirmar la transacción
        COMMIT;
    END TRY
    BEGIN CATCH
        -- En caso de error, hacer rollback de la transacción
        IF @@TRANCOUNT > 0
            ROLLBACK;

        -- Registrar el error
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
