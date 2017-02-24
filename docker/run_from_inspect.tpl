docker run \
    --name={{.Name}} \
    {{range $e := .Config.Env}}--env={{printf "%q" $e}} \
    {{end}}{{range $p, $conf := .NetworkSettings.Ports}}{{with $conf}}-p {{(index $conf 0).HostIp}}:{{(index $conf 0).HostPort}}:{{$p}} \
    {{end}}{{end}}{{range $n, $conf := .NetworkSettings.Networks}}{{with $conf}}--network {{printf "%q" $n}} \
    {{range $conf.Aliases}}--network-alias {{printf "%q" .}} {{end}} \
    {{end}}{{end}}{{range $v := .HostConfig.VolumesFrom}}--volumes-from={{printf "%q" .}} \
    {{end}}{{range $v := .HostConfig.Binds}}--volume={{printf "%q" .}} \
    {{end}}{{range $l, $v := .Config.Labels}}--label {{printf "%q" $l}}={{printf "%q" $v}} \
    {{end}}{{range $v := .HostConfig.CapAdd}}--cap-add {{printf "%q" .}} \
    {{end}}{{range $v := .HostConfig.CapDrop}}--cap-drop {{printf "%q" .}} \
    {{end}}{{range $d := .HostConfig.Devices}}--device={{printf "%q" (index $d).PathOnHost}}:{{printf "%q" (index $d).PathInContainer}}:{{(index $d).CgroupPermissions}} \
    {{end}}{{range $v := .Config.Entrypoint}}--entrypoint={{printf "%q" .}} \
    {{end}}{{with .HostConfig.LogConfig}}--log-driver={{printf "%q" .Type}} \
    {{range $o, $v := .Config}}--log-opt {{$o}}={{printf "%q" $v}} \
    {{end}}{{end}}{{with .HostConfig.RestartPolicy}}--restart="{{.Name}}{{if eq .Name "on-failure"}}{{.MaximumRetryCount}}{{end}}" \
    {{end}}{{if .Config.Tty}}-t \
    {{end}}{{if .Config.OpenStdin}}-i \
    {{end}}{{if not (.Config.AttachStdout)}}--detach=true \
    {{end}}{{if .HostConfig.Privileged}}--privileged \
    {{end}}{{printf "%q" .Config.Image}} \
    {{range .Config.Cmd}}{{printf "%q" .}} {{end}}
