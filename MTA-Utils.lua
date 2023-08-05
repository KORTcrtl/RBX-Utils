local TimeTable = {};

function ETempo(element, time, StringFunction) --[[ armazena um timer e executa uma função quanto o tempo acabar  ]]
    if not (element) then outputDebugString('ELemento, Não referenciado na função: ETempo', 3, 255, 100, 200) end
    if not (time) then outputDebugString('Tempo, Não referenciado na função: ETempo', 3, 255, 100, 200) end
    if not (StringFunction) then outputDebugString('Função, Não referenciado na função: ETempo, Obs... Função tem que ser passada em string', 3, 255, 100, 200) end

    setTimer(function(element)
        loadstring(tostring(StringFunction))
    end, 1, tonumber(time), element)

end