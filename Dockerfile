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
FROM mcr.microsoft.com/dotnet/sdk:5.0

COPY --from=builder /goof /goof

WORKDIR /goof/dotNETGoofV2.Website
EXPOSE 5001
EXPOSE 5000
RUN dotnet dev-certs https
ENTRYPOINT [ "dotnet", "watch", "run", "--urls", "https://0.0.0.0:5000"]