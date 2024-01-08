import pandas as pd
import json

# Manejo de errores con try-except para la lectura del archivo JSON
try:
    with open('taylor_swift_spotify.json', 'r') as archivo:
        data = json.load(archivo)
except FileNotFoundError:
    print("El archivo JSON no se encuentra.")
    data = {}

# Crear listas para almacenar datos
dataframe = []

# Extraer información del diccionario
try:
    artist_info = {
        "artist_id": data.get("artist_id", ""),
        "artist_name": data.get("artist_name", ""),
        "artist_popularity": data.get("artist_popularity", "")
    }
    dataframe.append(artist_info)
except KeyError:
    print("No se pudo extraer información del artista.")

# Iterar sobre álbumes y canciones
for album in data.get("albums", []):
    try:
        album_info = {
            "album_id": album.get("album_id", ""),
            "album_name": album.get("album_name", ""),
            "album_release_date": album.get("album_release_date", ""),
            "album_total_tracks": album.get("album_total_tracks", "")
        }
        dataframe.append(album_info)

        for track in album.get("tracks", []):
            try:
                track_info = {
                    "disc_number": track.get("disc_number", ""),
                    "duration_ms": track.get("duration_ms", ""),
                    "explicit": track.get("explicit", ""),
                    "track_number": track.get("track_number", ""),
                    "track_popularity": track.get("track_popularity",""),
                    "track_id": track.get("audio_features", {}).get("id", ""),
                    "track_name": track.get("track_name", ""),
                    "audio_features.danceability": track.get("audio_features", {}).get("danceability", ""),
                    "audio_features.energy": track.get("audio_features", {}).get("energy", ""),
                    "audio_features.key": track.get("audio_features", {}).get("key", ""),
                    "audio_features.loudness": track.get("audio_features", {}).get("loudness", ""),
                    "audio_features.mode": track.get("audio_features", {}).get("mode", ""),
                    "audio_features.speechiness": track.get("audio_features", {}).get("speechiness", ""),
                    "audio_features.acousticness": track.get("audio_features", {}).get("acousticness", ""),
                    "audio_features.instrumentalness": track.get("audio_features", {}).get("instrumentalness", ""),
                    "audio_features.liveness": track.get("audio_features", {}).get("liveness", ""),
                    "audio_features.valence": track.get("audio_features", {}).get("valence", ""),
                    "audio_features.tempo": track.get("audio_features", {}).get("tempo", ""),
                    "audio_features.id": track.get("audio_features", {}).get("id", ""),
                    "audio_features.time_signature": track.get("audio_features", {}).get("time_signature", ""),
                    "artist_id": data.get("artist_id", ""),
                    "artist_name": data.get("artist_name", ""),
                    "artist_popularity": data.get("artist_popularity", ""),
                    "album_id": album.get("album_id", ""),
                    "album_name": album.get("album_name", ""),
                    "album_release_date": album.get("album_release_date", ""),
                    "album_total_tracks": album.get("album_total_tracks", "")
                }
                dataframe.append(track_info)
            except KeyError:
                print("No se pudo extraer información de una canción.")
    except KeyError:
        print("No se pudo extraer información de un álbum.")

# Crear DataFrame
Info_df = pd.DataFrame(dataframe)

# Reorganizar las columnas en el orden deseado
column_order = [
    "disc_number", "duration_ms", "explicit", "track_number", "track_popularity",
    "track_id", "track_name",
    "audio_features.danceability", "audio_features.energy", "audio_features.key",
    "audio_features.loudness", "audio_features.mode", "audio_features.speechiness",
    "audio_features.acousticness", "audio_features.instrumentalness", "audio_features.liveness",
    "audio_features.valence", "audio_features.tempo", "audio_features.id",
    "audio_features.time_signature",
    "artist_id", "artist_name", "artist_popularity",
    "album_id", "album_name", "album_release_date", "album_total_tracks"
]

Info_df = Info_df[column_order]

# Eliminar las filas vacías por columna 'disc_number'
try:
    Info_df = Info_df.dropna(subset=['disc_number'])
except KeyError:
    print("No se pudo eliminar filas vacías por falta de la columna 'disc_number'.")

# Convertir columnas a tipo entero
try:
    Info_df['disc_number'] = Info_df['disc_number'].astype(int)
    Info_df['duration_ms'] = Info_df['duration_ms'].astype(int)
    Info_df['track_number'] = Info_df['track_number'].astype(int)
    Info_df['track_popularity'] = Info_df['track_popularity'].astype(int)
    Info_df['audio_features.mode'] = Info_df['audio_features.mode'].astype(int)
    Info_df['artist_popularity'] = Info_df['artist_popularity'].astype(int)
except KeyError:
    print("No se pudo convertir columnas a tipo entero debido a columnas faltantes.")

# Mostrar el DataFrame de las canciones
print(Info_df)

# Exportar el DataFrame combinado a un archivo CSV
try:
    Info_df.to_csv('dataset.csv', sep=';', index=False)
    print("El archivo CSV se ha creado correctamente.")
except PermissionError:
    print("No se pudo crear el archivo CSV debido a problemas de permisos.")

