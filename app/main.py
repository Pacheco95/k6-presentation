import asyncio
import sys
from uuid import uuid4

from fastapi import FastAPI, Request, Response, APIRouter, Query
from fastapi.routing import APIRoute
from starlette.background import BackgroundTask
from starlette import status
from typing import Callable


def fibonacci(n: int):
    if n == 1:
        return 0

    if n == 2:
        return 1

    return fibonacci(n - 1) + fibonacci(n - 2)


def log_request(req: Request):
    fmt = "[{}][{} {}?{}]"
    print(
        fmt.format(req.state.id, req.method, req.url.path, req.url.query),
        file=sys.stderr,
    )


def log_response(req: Request, res: Response):
    fmt = "[{}][{}] -> {}"
    print(
        fmt.format(req.state.id, res.status_code, res.body.decode()),
        file=sys.stderr,
    )


class LoggingRoute(APIRoute):
    def get_route_handler(self) -> Callable:
        original_route_handler = super().get_route_handler()

        async def custom_route_handler(request: Request) -> Response:
            request.state.id = uuid4()
            log_request(request)
            response = await original_route_handler(request)
            log_response(request, response)
            return response

        return custom_route_handler


router = APIRouter(route_class=LoggingRoute)

app = FastAPI()


@router.get("/sleep", status_code=status.HTTP_200_OK)
async def sleep(t: float = Query(ge=0)):
    await asyncio.sleep(t)
    return {}


@router.get("/fib", status_code=status.HTTP_200_OK)
def perform_intesive_cpu_task(n: int = Query(gt=0)):
    fib = fibonacci(n)
    return f"Fib({n}) = {fib}"


app.include_router(router)
