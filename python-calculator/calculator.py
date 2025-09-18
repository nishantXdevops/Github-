from flask import Flask, request, jsonify, render_template_string
import ast, operator as op

app = Flask(__name__)

# Allowed operators for safe evaluation
ALLOWED_OPERATORS = {
    ast.Add: op.add,
    ast.Sub: op.sub,
    ast.Mult: op.mul,
    ast.Div: op.truediv,
    ast.Mod: op.mod,
    ast.Pow: op.pow,
    ast.FloorDiv: op.floordiv,
}

ALLOWED_UNARY = {
    ast.UAdd: lambda x: x,
    ast.USub: lambda x: -x,
}

def safe_eval(expr: str):
    """Safely evaluate a math expression using AST"""
    try:
        node = ast.parse(expr, mode="eval")
    except:
        raise ValueError("Invalid expression")

    def _eval(node):
        if isinstance(node, ast.Expression):
            return _eval(node.body)
        if isinstance(node, ast.Constant):
            if isinstance(node.value, (int, float)):
                return node.value
            raise ValueError("Only numbers allowed")
        if isinstance(node, ast.BinOp):
            left, right = _eval(node.left), _eval(node.right)
            op_type = type(node.op)
            if op_type in ALLOWED_OPERATORS:
                if op_type in (ast.Div, ast.FloorDiv, ast.Mod) and right == 0:
                    raise ValueError("Division by zero")
                return ALLOWED_OPERATORS[op_type](left, right)
            raise ValueError("Operator not allowed")
        if isinstance(node, ast.UnaryOp):
            op_type = type(node.op)
            if op_type in ALLOWED_UNARY:
                return ALLOWED_UNARY[op_type](_eval(node.operand))
            raise ValueError("Unary operator not allowed")
        raise ValueError("Invalid syntax")

    return _eval(node)

# HTML template
TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Calculator</title>
    <style>
        body { font-family: Arial, sans-serif; display:flex; justify-content:center; align-items:center; height:100vh; background:#f3f4f6; margin:0; }
        .calc { background:white; padding:20px; border-radius:12px; box-shadow:0 6px 16px rgba(0,0,0,0.1); }
        input { width:100%; font-size:22px; padding:10px; margin-bottom:10px; border-radius:6px; border:1px solid #ddd; text-align:right; }
        button { width:60px; height:60px; font-size:20px; margin:5px; border:none; border-radius:6px; cursor:pointer; background:#e5e7eb; }
        button:hover { background:#d1d5db; }
        .op { background:#f59e0b; color:white; }
        .eq { background:#10b981; color:white; width:130px; }
        .clear { background:#ef4444; color:white; width:100%; margin-top:10px; }
    </style>
</head>
<body>
    <div class="calc">
        <input type="text" id="display" disabled>
        <br>
        <div>
            <button onclick="press('7')">7</button>
            <button onclick="press('8')">8</button>
            <button onclick="press('9')">9</button>
            <button class="op" onclick="press('/')">÷</button>
        </div>
        <div>
            <button onclick="press('4')">4</button>
            <button onclick="press('5')">5</button>
            <button onclick="press('6')">6</button>
            <button class="op" onclick="press('*')">×</button>
        </div>
        <div>
            <button onclick="press('1')">1</button>
            <button onclick="press('2')">2</button>
            <button onclick="press('3')">3</button>
            <button class="op" onclick="press('-')">−</button>
        </div>
        <div>
            <button onclick="press('0')">0</button>
            <button onclick="press('.')">.</button>
            <button class="eq" onclick="calculate()">=</button>
            <button class="op" onclick="press('+')">+</button>
        </div>
        <button class="clear" onclick="clearDisplay()">Clear</button>
    </div>

    <script>
        let expr = "";
        function press(val) {
            expr += val;
            document.getElementById("display").value = expr;
        }
        function clearDisplay() {
            expr = "";
            document.getElementById("display").value = "";
        }
        function calculate() {
            fetch("/calc", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ expression: expr })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    document.getElementById("display").value = data.result;
                    expr = data.result;
                } else {
                    alert("Error: " + data.error);
                }
            });
        }
    </script>
</body>
</html>
"""

@app.route("/")
def index():
    return render_template_string(TEMPLATE)

@app.route("/calc", methods=["POST"])
def calc():
    try:
        data = request.get_json()
        expr = data.get("expression", "").strip()
        if not expr:
            return jsonify(success=False, error="Empty expression")
        result = safe_eval(expr)
        return jsonify(success=True, result=str(result))
    except Exception as e:
        return jsonify(success=False, error=str(e))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
