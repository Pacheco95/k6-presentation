import asyncio
from starlette import status
from fastapi import FastAPI

app = FastAPI()


def fibonacci(n: int):
    if n == 1:
        return 0

    if n == 2:
        return 1

    return fibonacci(n - 1) + fibonacci(n - 2)


@app.get("/sleep", status_code=status.HTTP_200_OK)
async def perform_intesive_cpu_task(t: float = 0):
    await asyncio.sleep(t)
    return {}


@app.get("/fib", status_code=status.HTTP_200_OK)
def perform_intesive_cpu_task(n: int = 0):
    fib = fibonacci(n)
    return f"Fib({n}) = {fib}"
