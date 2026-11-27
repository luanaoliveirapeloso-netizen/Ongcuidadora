# OngCuidadora

Projeto Integrador Extensionista II — front-end com Vite+ e API Express.

## Requisitos

- Node.js 20.6 ou superior
- Vite+ (`vp`)

## Como rodar

```bash
git clone https://github.com/luanaoliveirapeloso-netizen/Ongcuidadora
cd ongcuidadora
vp install
cp .env.example .env
```

Terminal 1 (API):

```bash
vp run api
```

Terminal 2 (front-end):

```bash
vp dev
```

Abra http://localhost:5173. A página deve mostrar **Status da API: ok** com data e hora.

## Rotas da API

| Método | Rota          | Resposta                                   |
|--------|---------------|--------------------------------------------|
| GET    | `/api/health` | `{ "status": "ok", "timestamp": "..." }`   |
