# BUILD
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .
RUN dotnet restore

# EF 
RUN dotnet tool install --global dotnet-ef --version 8.0.2
ENV PATH="$PATH:/root/.dotnet/tools"

# bundle
RUN dotnet ef migrations bundle \
--project DotNetCrudWebApi/DotNetCrudWebApi.csproj \
 -o /out/efbundle

# publish
RUN dotnet publish -c Release -o /out


# RUNTIME
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

EXPOSE 8080

COPY --from=build /out .

RUN mkdir -p /app/Data && chmod 777 /app/Data


ENTRYPOINT ["/bin/sh", "-c", "./efbundle && dotnet DotNetCrudWebApi.dll"]