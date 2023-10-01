import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '5s', target: 20 },
        { duration: '30s', target: 100 },
        { duration: '20s', target: 0 },
        { duration: '10s', target: 200 },
        { duration: '3s', target: 0 },
    ],
    thresholds: {
        http_req_failed: ['rate<0.01'], // http errors should be less than 1%
        http_req_duration: ['p(95)<2000'], // 95% of requests should be below 200ms
    },
};

const randomInt = Math.trunc(Math.random() * 20 + 20);

export default function () {
    const res = http.get(`http://0.0.0.0:8000/fib?n=${randomInt}`);
    check(res, { 'status was 200': (r) => r.status == 200 });
    sleep(1);
}
