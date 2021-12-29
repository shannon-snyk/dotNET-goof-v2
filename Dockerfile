# docker build -t appsecco/owasp-webgoat-dot-net .
# docker run --name webgoat -it -p 9000:9000 -d appsecco/owasp-webgoat-dot-net

#Stage One
FROM mcr.microsoft.com/dotnet/sdk:5.0 as builder

COPY . goof

RUN cd /goof && \
   dotnet restore

#Stage Two - Snyk

FROM snyk/snyk:dotnet as snyk

COPY --from=builder /goof /goof

CMD ["snyk", "test --file=/goof/dotNETGoofV2.sln --json"]

#Stage Three - App
FROM ubuntu

EXPOSE 9000
