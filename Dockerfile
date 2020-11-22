FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["AspNetCoreOnDocker.csproj", "./"]
RUN dotnet restore "AspNetCoreOnDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AspNetCoreOnDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspNetCoreOnDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspNetCoreOnDocker.dll"]
