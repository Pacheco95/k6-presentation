import asyncio
from starlette import status
from fastapi import FastAPI

app = FastAPI()


@app.get("/", status_code=status.HTTP_200_OK)
async def timeout_handler(t: float = 0):
    await asyncio.sleep(t)
    return {}
