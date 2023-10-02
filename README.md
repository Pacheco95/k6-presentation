# Tutorial - Teste de performance com K6
Esse repositório contém exemplos de testes de carga usando o [k6](https://k6.io/)

# Testes

```bash
# Execute a API com a quantidade de workers desejada
export workers=1
make run-api

# Execute o teste desejado
t=00-hello-world make test

# O teste `03-lifecycle+extensions` utiliza extensões k6, e portanto precisa de um binário customizado:

make build-k6
./k6 run test/03-lifecycle+extensions.js
```
