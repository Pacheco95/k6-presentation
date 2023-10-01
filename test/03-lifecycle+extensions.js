import http from 'k6/http';
import prompt from 'k6/x/prompt';
import { check, sleep } from 'k6';

export function setup() {
    const fib = prompt.readInt("Quer calcular o Fibonacci de qual número?")
    return {fib}
}


export default function ({fib}) {
    const res = http.get(`http://0.0.0.0:8000/fib?n=${fib}`);
    check(res, { 'status was 200': (r) => r.status == 200 });
    sleep(1);
}
