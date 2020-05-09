FROM mcr.microsoft.com/dotnet/core/sdk:3.1.201 AS build
#FROM mcr.microsoft.com/dotnet/core/sdk:3.1.100-preview3 AS build
WORKDIR /app
COPY . .
#RUN dotnet restore
RUN dotnet publish -c Release

FROM nginx:alpine
COPY --from=build /app/bin/Release/netstandard2.1/publish/wwwroot /usr/share/nginx/html/
# COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80