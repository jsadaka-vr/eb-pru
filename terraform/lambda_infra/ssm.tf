resource "aws_ssm_document" "BlackHoleByIPAddress" {
  name            = "BlackHoleByIPAddress"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/BlackHoleByIPAddress.yml")

}

resource "aws_ssm_document" "BlackHoleByPort" {
  name            = "BlackHoleByPort"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/BlackHoleByPort.yml")

}

resource "aws_ssm_document" "BlackholeKafka" {
  name            = "BlackholeKafka"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/BlackHoleKafka.yml")

}

resource "aws_ssm_document" "BlockNetworkTrafficOnInstance" {
  name            = "BlockNetworkTrafficOnInstance"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/BlockNetworkTrafficOnInstance.yml")

}

resource "aws_ssm_document" "DeletePod" {
  name            = "DeletePod"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/DeletePod.yml")

}

resource "aws_ssm_document" "DetachVolume" {
  name            = "DetachVolume"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/DetachVolume.yml")

}

resource "aws_ssm_document" "DiskVolumeExhaustion" {
  name            = "DiskVolumeExhaustion"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/DiskVolumeExhaustion.yml")

}

resource "aws_ssm_document" "InstallStressNG" {
  name            = "InstallStressNG"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/InstallStressNG.yml")

}

resource "aws_ssm_document" "KillProcess" {
  name            = "KillProcess"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/KillProcess.yml")

}

resource "aws_ssm_document" "KillProcessByName" {
  name            = "KillProcessByName"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/KillProcessByName.yml")

}

resource "aws_ssm_document" "PodBlackholeByPort" {
  name            = "PodBlackholeByPort"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodBlackholeByPort.yml")

}

resource "aws_ssm_document" "PodHealthCheck" {
  name            = "PodHealthCheck"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodHealthCheck.yml")

}

resource "aws_ssm_document" "PodStressAllNetworkIO" {
  name            = "PodStressAllNetworkIO"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodStressAllNetworkIO.yml")

}

resource "aws_ssm_document" "PodStressCPU" {
  name            = "PodStressCPU"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodStressCPU.yml")

}

resource "aws_ssm_document" "PodStressIO" {
  name            = "PodStressIO"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodStressIO.yml")

}

resource "aws_ssm_document" "PodStressMemory" {
  name            = "PodStressMemory"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodStressMemory.yml")

}

resource "aws_ssm_document" "PodStressNetworkUtilization" {
  name            = "PodStressNetworkUtilization"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodStressNetworkUtilization.yml")

}

resource "aws_ssm_document" "PodTerminationCrash" {
  name            = "PodTerminationCrash"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/PodTerminationCrash.yml")

}

resource "aws_ssm_document" "ShutDownNetworkInterfaceOnInstance" {
  name            = "ShutDownNetworkInterfaceOnInstance"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/ShutDownNetworkInterfaceOnInstance.yml")

}

resource "aws_ssm_document" "StressAllNetworkIO" {
  name            = "StressAllNetworkIO"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/StressAllNetworkIO.yml")

}
resource "aws_ssm_document" "StressCPU" {
  name            = "StressCPU"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/StressCPU.yml")

}

resource "aws_ssm_document" "StressIO" {
  name            = "StressIO"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/StressIO.yml")

}

resource "aws_ssm_document" "StressNetworkLatency" {
  name            = "StressNetworkLatency"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/StressNetworkLatency.yml")

}

resource "aws_ssm_document" "StressMemory" {
  name            = "StressMemory"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/StressMemory.yml")

}

resource "aws_ssm_document" "StressPacketLoss" {
  name            = "StressPacketLoss"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/StressPacketLoss.yml")

}  

resource "aws_ssm_document" "StressNetworkUtilization" {
  name            = "StressNetworkUtilization"
  document_type   = "Command"
  document_format = "YAML"

  content = file("ssm/StressNetworkUtilization.yml")

}  