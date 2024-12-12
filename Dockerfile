FROM amazonlinux
LABEL maintainer="sethabrock@gmail.com"

# Install Dependencies
RUN yum -y update && \
    yum -y install wget tar gzip git glibc libgcc libstdc++ libicu zlib && \
    yum clean all

# Install .NET 8.0
WORKDIR /tmp
RUN wget https://dotnetcli.azureedge.net/dotnet/Sdk/8.0.404/dotnet-sdk-8.0.404-linux-x64.tar.gz
RUN mkdir -p /usr/share/dotnet && \
    tar -xvf dotnet-sdk-8.0.404-linux-x64.tar.gz -C /usr/share/dotnet && \
    rm dotnet-sdk-8.0.404-linux-x64.tar.gz

# Set up the environment
ENV PATH="/usr/share/dotnet:$PATH"

# Default working directory
WORKDIR /app

# Download the web app
RUN git clone --depth 1 https://github.com/sethbr11/pdcdonuts.git .
RUN dotnet restore && dotnet build

# Expose the port (change from 5000 to 80)
EXPOSE 80

# Set ASP.NET Core to use port 80
ENV ASPNETCORE_URLS="http://0.0.0.0:80"

# Pull latest changes from the repository and run the app
CMD git pull origin main && dotnet bin/Debug/net8.0/donuts.dll
