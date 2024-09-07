let body = process.env["INPUT_PRBODY"];

/*
PR Template의 resolved issue 넘버 표기 방식 변경 시 해당 코드 또한 변경 필요
*/
let pattern = /Resolves: #\d+/;

let issueNumber;

try {
  issueNumber = body.match(pattern)[0].replace("Resolves: #", "").trim();
} catch {
  issueNumber = -1;
}

console.log(`::set-output name=issueNumber::${issueNumber}`);
