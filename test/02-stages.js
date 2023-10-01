import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '5s', target: 20 },
        { duration: '30s', target: 100 },
        { duration: '20s', target: 0 },
    ],
};

const randomInt = Math.trunc(Math.random() * 20 + 20);

export default function () {
    const res = http.get(`http://0.0.0.0:8000/fib?n=${randomInt}`);
    check(res, { 'status was 200': (r) => r.status == 200 });
    sleep(1);
}
