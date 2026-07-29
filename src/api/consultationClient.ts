export type ConsultationRequest = {
  fullName: string
  email: string
  phone: string
  serviceType: string
  propertyType: string
  estimatedArea: number | null
  budget: string
  projectLocation: string
  message: string
  pagePath: string
  acceptedPrivacy: boolean
  website: string
}

export type ConsultationResponse = {
  id?: number
  message: string
}

type ApiErrorResponse = {
  message?: string
  title?: string
  errors?: Record<string, string[]>
}

const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || 'https://localhost:44328').replace(
  /\/$/,
  ''
)

export async function submitConsultation(
  request: ConsultationRequest
): Promise<ConsultationResponse> {
  const response = await fetch(`${apiBaseUrl}/api/booking-requests`, {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(request)
  })

  const result = (await response.json().catch(() => null)) as
    | ConsultationResponse
    | ApiErrorResponse
    | null

  if (!response.ok) {
    const validationMessage =
      result && 'errors' in result
        ? Object.values(result.errors ?? {})
            .flat()
            .find(Boolean)
        : undefined
    const message =
      validationMessage ||
      (result && 'message' in result ? result.message : undefined) ||
      (result && 'title' in result ? result.title : undefined)

    throw new Error(message || 'Không thể gửi yêu cầu lúc này. Vui lòng thử lại sau.')
  }

  return result as ConsultationResponse
}
