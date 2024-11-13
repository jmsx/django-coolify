# Usa la imagen base oficial de Python 3.9 slim
FROM python:3.12-slim

# Establece el directorio de trabajo en /app
WORKDIR /app

# Instala dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Copia el archivo de requisitos al directorio de trabajo
COPY requirements.txt .

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código de la aplicación al contenedor
COPY . .

# Crear directorios para archivos estáticos y de media
RUN mkdir -p static media

# Expone el puerto 8000
EXPOSE 8000

# Ejecuta las migraciones y lanza el servidor con Gunicorn
CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn djangoCoolify.wsgi:application --bind 0.0.0.0:8000"]
