$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
                $("#span").text('Último valor investido: '+item.saldo);
                $("#span2").text('Seu lucro é de '+(item.saldo*0.05));
            } else {
                display(false)
            }
        }
    })
    //Quando clicar para fechar, ele fecha a NUI
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $('input[name=mizera').val('');
            $.post('http://nav_invest/exit', JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $('input[name=mizera').val('');
        $.post('http://nav_invest/exit', JSON.stringify({}));
        return
    })

    //Sacar o lucro
    $("#sacar").click(function () {
        $('input[name=mizera').val('');
        $.post('http://nav_invest/sacar', JSON.stringify({
            lucro: "Deu erro não, é sucesso!"
        }))
        return
    })


    //Quando clicar em enviar, executa esta caceta
    $("#submit").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $('input[name=mizera').val('');
            $.post("http://nav_invest/error", JSON.stringify({
                error: "Mais de 100 caracteres"
            }))
            return
        } else if (!inputValue) {
            $('input[name=mizera').val('');
            $.post("http://nav_teste/error", JSON.stringify({
                error: "Nenhum valor no input"
            }))
            return
        } else if (isNaN(inputValue)) {
            $('input[name=mizera').val('');
            $.post("http://nav_invest/error", JSON.stringify({
                error: "Apenas números"
            }))
            return
        }
        //Se não houver erros acima, podemos enviar os dados de volta para o retorno de chamada original e manipulá-los a partir daí
        $('input[name=mizera').val('');
        $.post('http://nav_invest/comprar', JSON.stringify({
            text: inputValue,
        }));
        return;
    })
})