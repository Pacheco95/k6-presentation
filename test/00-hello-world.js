import http from 'k6/http';
import { check, sleep } from 'k6';

export default function () {
    const response = http.get("http://0.0.0.0:8000/sleep?t=50");
    check(response, {"status 200": (r) => r.status == 200})
    sleep(1);
}
