FROM mcr.microsoft.com/dotnet/core/sdk:3.1.201 AS build
WORKDIR /app
COPY . .
RUN dotnet publish -c Release

FROM nginx:alpine
COPY --from=build /app/bin/Release/netstandard2.1/publish/wwwroot /usr/share/nginx/html/
EXPOSE 80